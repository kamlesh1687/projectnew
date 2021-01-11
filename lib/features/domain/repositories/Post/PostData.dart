import 'package:projectnew/features/data/models/postModel.dart';
import 'package:projectnew/features/data/datasources/remote/postService.dart';

PostService postService = PostService();



abstract class PostData {
  Future<List<PosT>> getPosts(String _userId);
  Future<PosT> getSinglePost(String _postId);
  void uploadPost(PosT _post);
  void updatePosts(PosT _post);
  void deletePosts(String _postId);
}
