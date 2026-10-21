import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkvault/screens/privateVault/private_vault_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/utiles.dart';
import '../../data/repositories/link_repository.dart';
import '../../resources/colors/app_colors.dart';
import 'forgot_pin_warning_screen.dart';


enum PinScreenMode {
  setup,  // Creating a new 4-digit PIN (Confirm step included)
  verify, // Unlocking Private Vault
  change, // Verifying old PIN -> Setting new PIN
}

class VaultPinScreen extends StatefulWidget {
  final PinScreenMode mode;
  final bool openVaultOnSuccess;

  const VaultPinScreen({
    super.key,
    required this.mode,
    this.openVaultOnSuccess = false,
  });

  @override
  State<VaultPinScreen> createState() => _VaultPinScreenState();
}

class _VaultPinScreenState extends State<VaultPinScreen> {
  final LinkRepository _repository = LinkRepository();

  String _enteredPin = '';
  String _firstSetupPin = '';
  bool _isConfirmingSetup = false;
  bool _isOldPinVerified = false;
  String? _errorText;

  String get _headerTitle {
    if (widget.mode == PinScreenMode.verify) {
      return "Enter Vault PIN";
    }
    if (widget.mode == PinScreenMode.change && !_isOldPinVerified) {
      return "Verify Current PIN";
    }
    if (_isConfirmingSetup) {
      return "Confirm 4-Digit PIN";
    }
    return "Set Private Vault PIN";
  }

  String get _headerSubtitle {
    if (widget.mode == PinScreenMode.verify) {
      return "Enter your 4-digit code to unlock private links";
    }
    if (widget.mode == PinScreenMode.change && !_isOldPinVerified) {
      return "Enter your existing 4-digit code to continue";
    }
    if (_isConfirmingSetup) {
      return "Re-enter the same 4-digit code to confirm";
    }
    return "Create a 4-digit code to protect your private links";
  }

  void _onDigitPress(String digit) {
    if (_enteredPin.length >= 4) return;
    AppHaptics.lightTap();

    setState(() {
      _errorText = null;
      _enteredPin += digit;
    });

    if (_enteredPin.length == 4) {
      Future.delayed(const Duration(milliseconds: 120), _handleCompletedPin);
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty) return;
    AppHaptics.lightTap();
    setState(() {
      _errorText = null;
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  Future<void> _handleCompletedPin() async {
    // 1. VERIFY MODE (Unlocking Private Vault)
    if (widget.mode == PinScreenMode.verify) {
      if (_repository.verifyVaultPin(_enteredPin)) {
        AppHaptics.mediumTap();
        if (widget.openVaultOnSuccess) {
          Get.off(() => const PrivateVaultScreen());
        } else {
          Get.back(result: true);
        }
      } else {
        AppHaptics.errorVibrate();
        setState(() {
          _errorText = "Incorrect PIN code. Please try again.";
          _enteredPin = '';
        });
      }
      return;
    }

    // 2. CHANGE MODE - Step 1: Verify Current PIN
    if (widget.mode == PinScreenMode.change && !_isOldPinVerified) {
      if (_repository.verifyVaultPin(_enteredPin)) {
        AppHaptics.mediumTap();
        setState(() {
          _isOldPinVerified = true;
          _enteredPin = '';
          _errorText = null;
        });
      } else {
        AppHaptics.errorVibrate();
        setState(() {
          _errorText = "Current PIN is incorrect.";
          _enteredPin = '';
        });
      }
      return;
    }

    // 3. SETUP MODE (Or CHANGE MODE Step 2)
    if (!_isConfirmingSetup) {
      setState(() {
        _firstSetupPin = _enteredPin;
        _enteredPin = '';
        _isConfirmingSetup = true;
        _errorText = null;
      });
    } else {
      if (_enteredPin == _firstSetupPin) {
        await _repository.saveVaultPin(_enteredPin);
        AppHaptics.mediumTap();
        Utils.showSuccessToast("Private Vault PIN saved!");

        if (widget.openVaultOnSuccess) {
          Get.off(() => const PrivateVaultScreen());
        } else {
          Get.back(result: true);
        }
      } else {
        AppHaptics.errorVibrate();
        setState(() {
          _errorText = "PIN codes did not match. Start over.";
          _enteredPin = '';
          _firstSetupPin = '';
          _isConfirmingSetup = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textColorBlack),
          onPressed: () => Get.back(result: false),
        ),
      ),
      body: SafeArea(
        child: isLandscape
            ? Row(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildHeaderAndDots(),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: _buildKeypad(compact: true),
                ),
              ),
            ),
          ],
        )
            : Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildHeaderAndDots(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
              child: _buildKeypad(compact: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAndDots() {
    final showForgotBtn = widget.mode == PinScreenMode.verify ||
        (widget.mode == PinScreenMode.change && !_isOldPinVerified);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.iconBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.lock, color: AppColors.iconBlue, size: 28),
        ),
        const SizedBox(height: 18),
        Text(
          _headerTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textColorBlack,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _headerSubtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.subTitleColorGary,
          ),
        ),
        const SizedBox(height: 28),

        // 4 PIN Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isFilled = index < _enteredPin.length;
            final hasError = _errorText != null;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: isFilled ? 18 : 16,
              height: isFilled ? 18 : 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasError
                    ? AppColors.dangerRed
                    : (isFilled ? AppColors.iconBlue : Colors.transparent),
                border: Border.all(
                  color: hasError
                      ? AppColors.dangerRed
                      : (isFilled ? AppColors.iconBlue : Colors.black26),
                  width: 2,
                ),
              ),
            );
          }),
        ),

        if (_errorText != null) ...[
          const SizedBox(height: 16),
          Text(
            _errorText!,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.dangerRed,
            ),
          ),
        ],

        if (showForgotBtn) ...[
          const SizedBox(height: 18),
          TextButton(
            onPressed: () {
              AppHaptics.lightTap();
              Get.to(() => ForgotPinWarningScreen(
                openVaultAfterReset: widget.openVaultOnSuccess,
              ));
            },
            child: Text(
              "Forgot PIN?",
              style: GoogleFonts.manrope(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.iconBlue,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildKeypad({required bool compact}) {
    final double btnSize = compact ? 58 : 72;
    final double rowSpacing = compact ? 10 : 14;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildKeypadRow(['1', '2', '3'], btnSize),
        SizedBox(height: rowSpacing),
        _buildKeypadRow(['4', '5', '6'], btnSize),
        SizedBox(height: rowSpacing),
        _buildKeypadRow(['7', '8', '9'], btnSize),
        SizedBox(height: rowSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: btnSize, height: btnSize),
            _buildDigitButton('0', btnSize),
            InkWell(
              onTap: _onBackspace,
              borderRadius: BorderRadius.circular(btnSize / 2),
              child: SizedBox(
                width: btnSize,
                height: btnSize,
                child: const Icon(
                  LucideIcons.delete,
                  color: AppColors.textColorBlack,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> digits, double btnSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _buildDigitButton(d, btnSize)).toList(),
    );
  }

  Widget _buildDigitButton(String digit, double size) {
    return InkWell(
      onTap: () => _onDigitPress(digit),
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          digit,
          style: GoogleFonts.manrope(
            fontSize: size * 0.36,
            fontWeight: FontWeight.w800,
            color: AppColors.textColorBlack,
          ),
        ),
      ),
    );
  }
}