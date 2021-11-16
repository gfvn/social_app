import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/shared/componets/components.dart';
import 'package:social/shared/styles/icon_broken.dart';

class CommentScreen extends StatelessWidget {
  var _textCommentController = TextEditingController();

  final String uIdIndex;

  CommentScreen({
    required this.uIdIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
            appBar: defaultAppBar(
              context: context,
              text: '',
              leading: IconButton(
                icon: Icon(IconBroken.Arrow___Left_2),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: SingleChildScrollView(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => commentItem(
                                context,
                                SocialCubit.get(context)
                                    .commentModelAdd[index]),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8.0,
                            ),
                            itemCount: cubit.commentModelAdd.length,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _textCommentController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        hintText: 'Write a Comment',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        prefixIcon: InkWell(
                          child: const Icon(Icons.camera_alt),
                          onTap: () {
                            cubit.getCommentImage();
                          },
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (cubit.createCommentImage == null) {
                              cubit.getCommentPost(
                                textComment: _textCommentController.text,
                                uIdComment: uIdIndex,
                                postId: uIdIndex,
                              );
                            } else {
                              cubit.uploadCommentImage(
                                textComment: _textCommentController.text,
                                uIdComment: uIdIndex,
                                postId: uIdIndex,
                              );
                            }
                            _textCommentController.clear();
                          },
                          icon: const Icon(
                            Icons.send,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black, height: 1),
                    ),
                  ],
                )));
      },
    );
  }

  Widget commentItem(context, CommentModel model) {
    return Column(
      children: [
        if(model.postId == uIdIndex)
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                '${model.image}',
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${model.name}',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 18.0,
                              color: Colors.black,
                              height: 1.0,
                            ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Text(
                      '${model.textComment}',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          height: 1.6, fontSize: 15, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}