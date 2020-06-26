class Message {
  final String title;
  final String body;

  Message({
    this.title,
    this.body,
  });

  factory Message.fromJson(dynamic json) {
    return Message(
      title: json["title"],
      body: json["body"],
    );
  }
}

class NotificationModel {
  final Message notification;
  final dynamic data;

  NotificationModel({this.notification, this.data});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationModel model = NotificationModel(
      notification: Message.fromJson(json["notification"]),
      data: json["data"],
    );
    return model;
  }
}
