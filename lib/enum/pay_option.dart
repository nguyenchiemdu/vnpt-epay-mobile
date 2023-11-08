// ignore_for_file: constant_identifier_names
/// Only Supported for ATM and Credit Card Payment methods
enum PayOption {
  // Pay with ATM or Credit Card and create Token for the next time
  PAY_CREATE_TOKEN,
  // Pay with token without enter card information again
  PAY_WITH_TOKEN,
}
