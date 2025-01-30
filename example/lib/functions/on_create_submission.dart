import 'package:dartblaze/dartblaze.dart';
import 'package:dart_firebase_admin/messaging.dart';
import 'package:functions_framework/functions_framework.dart';

@OnDocumentCreated('submissions/{submissionId}')
Future<void> oncreatesubmission(
  DocumentSnapshot snapshot,
  RequestContext context, {
  required String submissionId,
}) async {
  final submittedByUserId = snapshot.data()?['submittedByUserId'] as String?;
  if (submittedByUserId != null) {
    await snapshot.ref.update({'isVerified': true});
    context.logger.debug(
      'submission ($submissionId) submitted by $submittedByUserId is verified',
    );
    final userFcmTokenDocumentSnapshot = await firestore
        .collection('userFcmTokens')
        .doc(submittedByUserId)
        .get();
    final token = userFcmTokenDocumentSnapshot.data()?['token'] as String?;
    if (token != null) {
      const title = 'Submission Verified';
      const body = 'Your submission is verified!';
      final messageId = await messaging.send(
        TokenMessage(
          token: token,
          data: {
            'title': title,
            'body': body,
            'location': '',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          notification: Notification(title: title, body: body),
          apns: ApnsConfig(
            headers: {'apns-priority': '10'},
            payload: ApnsPayload(
              aps: Aps(
                contentAvailable: true,
                badge: 1,
                sound: null,
                alert: null,
                mutableContent: null,
                category: null,
                threadId: null,
              ),
            ),
          ),
          android: AndroidConfig(
            priority: AndroidConfigPriority.high,
            notification: AndroidNotification(
              priority: AndroidNotificationPriority.max,
              defaultSound: true,
              channelId: 'high-priority-channel',
              notificationCount: 1,
            ),
          ),
        ),
      );
      context.logger.debug(
        'message ($messageId) is sent to user ($submittedByUserId)',
      );
    }
  } else {
    context.logger.debug(
      '''submission ($submissionId) is not verified because submittedByUserId is null''',
    );
  }
}
