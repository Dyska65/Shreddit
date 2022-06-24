import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreddit/network/models/post.dart';
import 'package:shreddit/network/models/user.dart';
import 'package:shreddit/utils.dart';

abstract class FirebaseManager {
  Future<AuthorizationResult> registration(
      String email, String password, String userName, Gender gender);
  Future<AuthorizationResult> logIn(String email, String password);
  Future<List<Post>> getPosts(UserModel userModel);
  Future<bool> addPost(String title, String content);
  Future<bool> saveUserToFirebase(String email, String userName, Gender gender);
  Future<UserModel?> findUser(String email);
  Future<bool> deletePost(String id);
  Future<bool> logOut();
  Future<bool> updateUser(String newName, Gender gender);
  Future<bool> likePost(Post post, UserModel userModel);
  Future<bool> dislikePost(Post post, UserModel userModel);
}

class FirebaseManagerImpl implements FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<AuthorizationResult> registration(
      String email, String password, String userName, Gender gender) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      bool isUserSaved = await saveUserToFirebase(email, userName, gender);
      if (isUserSaved) {
        return AuthorizationResult.success;
      } else {
        if (FirebaseAuth.instance.currentUser != null) {
          FirebaseAuth.instance.currentUser!.delete();
        }
        return AuthorizationResult.error;
      }
    } on FirebaseAuthException catch (e) {
      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.currentUser!.delete();
      }
      if (e.code == 'weak-password') {
        return AuthorizationResult.errorPassword;
      } else if (e.code == 'email-already-in-use') {
        return AuthorizationResult.errorEmail;
      }
    } catch (e) {
      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.currentUser!.delete();
      }
      return AuthorizationResult.errorNetwork;
    }
    return AuthorizationResult.error;
  }

  @override
  Future<AuthorizationResult> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return AuthorizationResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthorizationResult.errorEmail;
      } else if (e.code == 'wrong-password') {
        return AuthorizationResult.errorPassword;
      }
    } catch (e) {
      return AuthorizationResult.errorNetwork;
    }
    return AuthorizationResult.error;
  }

  @override
  Future<UserModel?> findUser(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      final snapshot = await users.where("email", isEqualTo: email).get();
      for (var element in snapshot.docs) {
        if (element['email'] == email) {
          var foundedUser = UserModel(
              gender: stringToGender(element['gender']),
              idUser: element.id,
              email: element['email'],
              userName: element['userName'],
              likedPost: element["likedPost"],
              dislikedPost: element["dislikedPost"]);

          return foundedUser;
        }
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Post>> getPosts(UserModel userModel) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    final snapshot = await posts.get();
    List<Post> listPost = [];

    for (var doc in snapshot.docs) {
      UserReaction userReaction = UserReaction.noReaction;
      if (userModel.likedPost.contains(doc.id)) {
        userReaction = UserReaction.like;
      } else if (userModel.dislikedPost.contains(doc.id)) {
        userReaction = UserReaction.dislike;
      }
      listPost.add(Post(
          doc.id,
          doc['userName'],
          doc['title'],
          doc['content'],
          doc['likesCount'],
          doc['dislikeCount'],
          doc['publicationTime'],
          userReaction));
    }
    listPost.sort((a, b) => b.publicationTime.compareTo(a.publicationTime));
    return listPost;
  }

  @override
  Future<bool> saveUserToFirebase(
      String email, String userName, Gender gender) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      users.add({
        'gender': genderToString(gender),
        'email': email,
        'userName': userName,
        'likedPost': [],
        'dislikedPost': []
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> addPost(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    int date = DateTime.now().millisecondsSinceEpoch;
    UserModel userModel = userModelFromJson(prefs.getString('userModel') ?? '');
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    try {
      await posts.add({
        'userName': userModel.userName,
        'title': title,
        'content': content,
        'likesCount': 0,
        'dislikeCount': 0,
        'publicationTime': date
      });
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Future<bool> deletePost(String id) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    try {
      var post = await posts.doc(id).delete();
      print("Post Deleted");
      return true;
    } catch (error) {
      print("Failed to delete post: $error");
      return false;
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> updateUser(String newName, Gender gender) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final prefs = await SharedPreferences.getInstance();
    UserModel userModel = userModelFromJson(prefs.getString('userModel') ?? '');

    try {
      var user = await users
          .doc(userModel.idUser)
          .update({'userName': newName, 'gender': genderToString(gender)});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> likePost(Post post, UserModel userModel) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      var oldValueUser = await users.doc(userModel.idUser).get();
      List likedPost = oldValueUser['likedPost'];
      List dislikedPost = oldValueUser['dislikedPost'];
      likedPost.add(post.id);

      if (dislikedPost.contains(post.id)) {
        dislikedPost.remove(post.id);
        await users.doc(userModel.idUser).update({
          'dislikedPost': dislikedPost,
          'likedPost': likedPost,
        });
        await posts.doc(post.id).update({
          'dislikeCount': post.dislikeCount,
          'likesCount': post.likesCount,
        });
      } else {
        await posts.doc(post.id).update({
          'likesCount': post.likesCount,
        });
        await users.doc(userModel.idUser).update({
          'likedPost': likedPost,
        });
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> dislikePost(Post post, UserModel userModel) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      var oldValueUser = await users.doc(userModel.idUser).get();
      List dislikedPost = oldValueUser['dislikedPost'];
      List likedPost = oldValueUser['likedPost'];
      dislikedPost.add(post.id);

      if (likedPost.contains(post.id)) {
        likedPost.remove(post.id);
        await users.doc(userModel.idUser).update({
          'likedPost': likedPost,
          'dislikedPost': dislikedPost,
        });
        await posts.doc(post.id).update({
          'likesCount': post.likesCount,
          'dislikeCount': post.dislikeCount,
        });
      } else {
        await posts.doc(post.id).update({
          'dislikeCount': post.dislikeCount,
        });
        await users.doc(userModel.idUser).update({
          'dislikedPost': dislikedPost,
        });
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
