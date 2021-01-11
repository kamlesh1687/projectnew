import 'package:projectnew/features/data/models/postModel.dart';
import 'package:projectnew/features/domain/repositories/Post/PostData.dart';

class PostDataImpl extends PostData {
  @override
  void deletePosts(String _postId) {
    try {} catch (e) {}
  }

  @override
  Future<List<PosT>> getPosts(String _userId) {
    try {
      return postService.getPostData(_userId).then((_qSnap) {
        return _qSnap
            .map((doc) => PosT.fromDocumentSnapshot(documentSnapshot: doc))
            .toList();
      });
    } catch (e) {}

    throw UnimplementedError();
  }

  @override
  Future<PosT> getSinglePost(String _postId) {
    try {} catch (e) {}
    throw UnimplementedError();
  }

  @override
  void updatePosts(PosT _post) {
    try {} catch (e) {}
  }

  @override
  void uploadPost(PosT _post) {
    try {} catch (e) {}
  }
}
