/// Central storage keys and configuration constants for LoginWizard
library;

// --- Username Keys ---
const String usernameFormatKey = 'username_format';
const String numberLengthKey = 'number_length';

// --- Password Keys ---
const String passwordLengthKey = 'password_length';
const String smallAlfaKey = 'az';
const String capAlfaKey = 'AZ';
const String numberskey = '09';
const String specialCharsKey = 'special_chars';
const String excludeAmbiguousKey = 'exclude_ambiguous';
const String customExcludeCharsKey = 'custom_exclude_chars';

// --- Passphrase Keys ---
const String passphraseLengthKey = 'passphrase_length';
const String passphraseSeparatorKey = 'passphrase_separator';
const String passphraseCapitalizeKey = 'passphrase_capitalize';
const String passphraseNumbersKey = 'passphrase_numbers';

// --- PIN Keys ---
const String pinLengthKey = 'pin_length';
const String pinAlphanumericKey = 'pin_alphanumeric';
const String pinAvoidPatternsKey = 'pin_avoid_patterns';
const String pinChunkFormatKey = 'pin_chunk_format';

// --- Settings & Security Keys ---
const String autoSaveHistoryKey = 'auto_save_history';
const String clipboardAutoClearSecondsKey = 'clipboard_auto_clear_seconds';
const String themeModeKey = 'theme_mode'; // 'system', 'light', 'dark'
