import '../imports.dart';

class TopicVoteButton extends StatefulWidget {
  const TopicVoteButton({
    super.key,
    required this.topicData,
  });

  final TopicWidgetData topicData;

  @override
  State<TopicVoteButton> createState() => _TopicVoteButtonState();
}

class _TopicVoteButtonState extends State<TopicVoteButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        if (!zeroNetController.userDataObj.topicVote
            .containsKey(widget.topicData.rowTopicUri)) {
          widget.topicData.votes += 1;

          zeroNetController
              .userDataObj.topicVote[widget.topicData.rowTopicUri] = 1;
        } else {
          widget.topicData.votes -= 1;

          zeroNetController.userDataObj.topicVote
              .remove(widget.topicData.rowTopicUri);
        }
        setState(() {});
        zeroNetController.saveUserData();

        //   widget.topic.isLiked =
        //       widget.topic.isLiked ? false : true;
        //   if (widget.topic.isLiked) {
        //     widget.topic.totalLikes++;
        //     tempLike = 0;
        //   } else {
        //     widget.topic.totalLikes--;
        //   }
        //   setState(() {});
        // },
        // hoverColor: Colors.green,
        // onHover: (value) {
        //   if (!widget.topic.isLiked) {
        //     if (value) {
        //       onLikeButtonHover = true;
        //       tempLike = 1;
        //     } else {
        //       tempLike = 0;
        //       onLikeButtonHover = false;
        //     }
        //     setState(() {});
        //   }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: threadItThemeController.currentTheme.value.primaryColor,
            width: 1,
          ),
          color: zeroNetController.userDataObj.topicVote
                  .containsKey(widget.topicData.rowTopicUri)
              ? Colors.green
              : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
          child: Center(
            child: Text(
              widget.topicData.votes.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopicCommentVoteButton extends StatefulWidget {
  const TopicCommentVoteButton({
    super.key,
    required this.commentData,
  });

  final CommentWidgetData commentData;

  @override
  State<TopicCommentVoteButton> createState() => _TopicCommentVoteButtonState();
}

class _TopicCommentVoteButtonState extends State<TopicCommentVoteButton> {
  @override
  Widget build(BuildContext context) {
    String commentUri =
        "${widget.commentData.commentId}_${widget.commentData.userAddress}";

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        if (!zeroNetController.userDataObj.commentVote
            .containsKey(commentUri)) {
          widget.commentData.votes += 1;

          zeroNetController.userDataObj.commentVote[commentUri] = 1;
        } else {
          widget.commentData.votes -= 1;

          zeroNetController.userDataObj.commentVote.remove(commentUri);
        }
        setState(() {});
        zeroNetController.saveUserData();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: threadItThemeController.currentTheme.value.primaryColor,
            width: 1,
          ),
          color:
              zeroNetController.userDataObj.commentVote.containsKey(commentUri)
                  ? Colors.green
                  : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
          child: Center(
            child: Text(
              widget.commentData.votes.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
