const {onDocumentCreated, onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

// Initialize the Admin SDK
initializeApp();

/**
 * Sends a push notification to a user.
 * @param {string} userId The UID of the user to send the notification to.
 * @param {string} title The title of the notification.
 * @param {string} body The body of the notification.
 * @return {Promise<string|null>} A promise that resolves when the message is sent.
 */
async function sendNotification(userId, title, body) {
  if (!userId) {
    console.log("Function triggered without a userId.");
    return null;
  }

  // Get the user's document from Firestore to find their FCM token
  const userDoc = await getFirestore().collection("users").doc(userId).get();
  if (!userDoc.exists) {
    console.log(`User document for UID ${userId} not found.`);
    return null;
  }

  const fcmToken = userDoc.data().fcmToken;
  if (!fcmToken) {
    console.log(`User ${userId} does not have an FCM token.`);
    return null;
  }

  // Construct the notification payload
  const payload = {
    notification: {
      title: title,
      body: body,
    },
    token: fcmToken,
  };

  try {
    console.log(`Attempting to send notification to token: ${fcmToken}`);
    await getMessaging().send(payload);
    console.log("Successfully sent notification.");
    return "Notification sent.";
  } catch (error) {
    console.error("Error sending notification:", error);
    return null;
  }
}

// Define the region for all functions to match your Firestore database
const functionOptions = {
  region: "asia-south1",
};

// Cloud Function that triggers when a NEW report is created
exports.onReportCreated = onDocumentCreated({
  ...functionOptions,
  document: "reports/{reportId}",
}, async (event) => {
  const reportData = event.data.data();
  const title = "Report Submitted Successfully!";
  const body = `Your report for "${reportData.category}" has been received.`;
  return sendNotification(reportData.userId, title, body);
});

// Cloud Function that triggers when a report is UPDATED
exports.onReportResolved = onDocumentUpdated({
  ...functionOptions,
  document: "reports/{reportId}",
}, async (event) => {
  const newData = event.data.after.data();
  const previousData = event.data.before.data();

  // Send notification only if the status was changed to "Resolved"
  if (newData.status === "Resolved" && previousData.status !== "Resolved") {
    const title = "Your Report is Resolved!";
    const body = `Your report for "${newData.category}" has been marked as resolved.`;
    return sendNotification(newData.userId, title, body);
  }
  return null; // No action needed for other updates
});