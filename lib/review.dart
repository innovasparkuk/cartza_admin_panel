import 'package:flutter/material.dart';
String id;
String userName;
String text;
double rating;
String? adminReply;
bool isApproved;
DateTime date;

Review({
  required this.id,
  required this.userName,
  required this.text,
  required this.rating,
  this.adminReply,
  this.isApproved = false,
  required this.date,
});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Review> _reviews = [
    Review(
      id: "1",
      userName: "Alex Johnson",
      text: "Great app! The user interface is clean and easy to navigate. I use it daily for my work.",
      rating: 5,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Review(
      id: "2",
      userName: "Maria Garcia",
      text: "It crashes occasionally when I try to login. Please fix this issue as it's quite frustrating.",
      rating: 2,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Review(
      id: "3",
      userName: "David Smith",
      text: "The product works fine for basic tasks. Could use some more advanced features though.",
      rating: 3,
      date: DateTime.now().subtract(Duration(days: 7)),
    ),
    Review(
      id: "4",
      userName: "Sarah Williams",
      text: "Excellent experience overall! Customer support was very helpful when I had questions.",
      rating: 4,
      date: DateTime.now().subtract(Duration(days: 10)),
    ),
    Review(
      id: "5",
      userName: "James Wilson",
      text: "The loading times could be better, but overall it's a solid app that does what it promises.",
      rating: 3,
      date: DateTime.now().subtract(Duration(days: 14)),
    ),
  ];

  final TextEditingController _replyController = TextEditingController();

  // Calculate average rating
  double get _averageRating {
    if (_reviews.isEmpty) return 0.0;
    double sum = 0;
    for (var review in _reviews) {
      sum += review.rating;
    }
    return sum / _reviews.length;
  }

  // Get rating distribution
  List<int> get _ratingDistribution {
    List<int> distribution = List.filled(5, 0);
    for (var review in _reviews) {
      int index = review.rating.clamp(1, 5).toInt() - 1;
      distribution[index]++;
    }
    return distribution;
  }

  // Format date to human readable
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "$weeks ${weeks == 1 ? 'week' : 'weeks'} ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  // Delete review
  void _deleteReview(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Review", style: TextStyle(color: Color(0xFF212121))),
        content: Text("Are you sure you want to delete this review? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Color(0xFF212121)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _reviews.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6F00),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              minimumSize: Size(80, 40),
            ),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Approve / Unapprove review
  void _toggleApproval(int index) {
    setState(() {
      _reviews[index].isApproved = !_reviews[index].isApproved;
    });
  }

  // Reply bottom sheet
  void _showReplySheet(int index) {
    _replyController.text = _reviews[index].adminReply ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reply to ${_reviews[index].userName}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Color(0xFF212121)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Your reply will be visible to everyone",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _replyController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your reply here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFF6F00)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFF6F00), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _replyController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF212121),
                        side: BorderSide(color: Colors.grey.shade400),
                        minimumSize: Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _reviews[index].adminReply = _replyController.text.trim();
                        });
                        _replyController.clear();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        minimumSize: Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Send Reply",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          "Customer Reviews",
          style: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6F00), Color(0xFF4CAF50)],
                stops: [0.3, 0.7],
              ),
            ),
          ),
        ),
      ),
      body: _reviews.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.reviews_outlined,
              size: 72,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 20),
            Text(
              "No Reviews Yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Customer reviews will appear here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Compact Rating Summary Card
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFFF6F00).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Average Rating Circle
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6F00), Color(0xFFFF8F00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF6F00).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "out of 5",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Star Rating
                      Row(
                        children: [
                          ...List.generate(
                            5,
                                (index) => Icon(
                              Icons.star,
                              size: 18,
                              color: index < _averageRating.floor()
                                  ? Color(0xFFFF6F00)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "${_reviews.length} reviews",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Rating Bars (simplified)
                      Column(
                        children: [
                          for (var i = 4; i >= 0; i--)
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Text(
                                    "${i + 1}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Color(0xFFFF6F00),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: FractionallySizedBox(
                                        widthFactor: _reviews.isEmpty
                                            ? 0
                                            : _ratingDistribution[i] / _reviews.length,
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: i >= 3
                                                ? Color(0xFF4CAF50)
                                                : i >= 2
                                                ? Color(0xFFFF6F00)
                                                : Colors.red.shade400,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "${_ratingDistribution[i]}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Reviews List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User info and rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF4CAF50),
                                          Color(0xFF8BC34A),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF4CAF50).withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        review.userName[0],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.userName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF212121),
                                        ),
                                      ),
                                      Text(
                                        _formatDate(review.date),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: review.rating >= 4
                                    ? Color(0xFF4CAF50).withOpacity(0.15)
                                    : review.rating >= 3
                                    ? Color(0xFFFF6F00).withOpacity(0.15)
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: review.rating >= 4
                                      ? Color(0xFF4CAF50).withOpacity(0.3)
                                      : review.rating >= 3
                                      ? Color(0xFFFF6F00).withOpacity(0.3)
                                      : Colors.red.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: review.rating >= 4
                                        ? Color(0xFF4CAF50)
                                        : review.rating >= 3
                                        ? Color(0xFFFF6F00)
                                        : Colors.red,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    review.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: review.rating >= 4
                                          ? Color(0xFF4CAF50)
                                          : review.rating >= 3
                                          ? Color(0xFFFF6F00)
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 14),

                        // Review text
                        Text(
                          review.text,
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        // Admin reply
                        if (review.adminReply != null) ...[
                          SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Color(0xFF4CAF50).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF4CAF50).withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified_user,
                                      size: 16,
                                      color: Color(0xFF4CAF50),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Admin Response",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  review.adminReply!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF212121),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 16),

                        // NEW BUTTON ROW - Clean and minimal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Approve Button
                            OutlinedButton(
                              onPressed: () => _toggleApproval(index),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: review.isApproved ? Color(0xFF4CAF50) : Color(0xFF212121),
                                side: BorderSide(
                                  color: review.isApproved ? Color(0xFF4CAF50) : Colors.grey.shade400,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    review.isApproved ? Icons.check_circle : Icons.circle_outlined,
                                    size: 16,
                                    color: review.isApproved ? Color(0xFF4CAF50) : Colors.grey.shade600,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    review.isApproved ? "Approved" : "Approve",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 10),

                            // Reply Button
                            ElevatedButton(
                              onPressed: () => _showReplySheet(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF6F00),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.reply,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    review.adminReply == null ? "Reply" : "Edit",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 10),

                            // Delete Button
                            OutlinedButton(
                              onPressed: () => _deleteReview(index),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFFEF5350),
                                side: BorderSide(
                                  color: Color(0xFFEF5350),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 16,
                                    color: Color(0xFFEF5350),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}