import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:speech/provider/authProviders/signUpProvider.dart';
import 'package:speech/ui/auth/singIn.dart';
import 'package:speech/ui/widgets/animatedBackground.dart';
import 'package:speech/ui/widgets/dialogs.dart';
import 'package:speech/ui/widgets/widgets.dart';

class _SignUpButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool accepted;

  const _SignUpButton({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.accepted,
    Key? key,
  }) : super(key: key);

  _onSignUp(BuildContext context, WidgetRef ref) async {
    if (formKey.currentState!.validate()) {
      if (!accepted) {
        Dialogs.toast(
          context: context,
          message: "Please accept our terms and policy",
          buttonText: "Close",
        );
        return;
      }

      await ref.read(signUpStateProvider.notifier).signUp(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            confirmPassword: confirmPasswordController.text,
          );

      final isOk =
          ref.read(signUpStateProvider).signUpUIState == SignUpUIState.OK;

      if (context.mounted) {
        if (isOk) {
          Navigator.pop(context);
        } else {
          final errorMessage = ref.read(signUpStateProvider).errorMessage ??
              "Error message: null";
          Dialogs.toast(
            context: context,
            message: errorMessage,
            buttonText: "Close",
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpStateProvider).signUpUIState;

    switch (state) {
      case SignUpUIState.LOADING:
        return AppWidgets.loadingAnimation();
      default:
        return CircleAvatar(
          backgroundColor: Colors.deepPurple,
          radius: 30,
          child: IconButton(
            onPressed: () => _onSignUp(context, ref),
            icon: const Icon(
              CupertinoIcons.arrow_right,
              color: Colors.white,
              size: 30,
            ),
          ),
        );
    }
  }
}

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  _onTermsOfService() {}

  _onPrivacyPolicy() {}

  _onSingIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

  Widget _signUp({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required bool accepted,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Sign Up",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        _SignUpButton(
          formKey: formKey,
          nameController: nameController,
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          accepted: accepted,
        ),
      ],
    );
  }

  Widget _acceptTermsAndPolicy({
    required BuildContext context,
    required ValueNotifier<bool> accepted,
  }) {
    Widget textButton({required VoidCallback onPressed, required String text}) {
      return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: IconButton(
        onPressed: () => accepted.value = !accepted.value,
        icon: Icon(
          accepted.value
              ? Icons.radio_button_checked_outlined
              : Icons.radio_button_off,
        ),
      ),
      title: FittedBox(
        child: Row(
          children: [
            Text(
              "I agree to the",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(width: 2),
            textButton(
              onPressed: () => _onTermsOfService(),
              text: "Terms of service",
            ),
            const SizedBox(width: 2),
            Text(
              "and",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(width: 2),
            textButton(
              onPressed: () => _onPrivacyPolicy(),
              text: "Privacy Policy",
            ),
          ],
        ),
      ),
    );
  }

  Widget _formFields({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required ValueNotifier<bool> passwordVisible,
    required ValueNotifier<bool> confirmPasswordVisible,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Get started",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontSize: 32,
              ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          validator: (value) => value != null && value.isNotEmpty
              ? null
              : "Please enter your name",
          controller: nameController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Name",
            labelStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          validator: (value) => value != null && validator.email(value)
              ? null
              : "Please enter a valid email",
          controller: emailController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email",
            labelStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          validator: (value) => value != null && value.isNotEmpty
              ? value.length > 7
                  ? null
                  : "password must be at least 8 characters"
              : "Please enter a valid password",
          controller: passwordController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          obscureText: !passwordVisible.value,
          decoration: InputDecoration(
              labelText: "Password",
              labelStyle: Theme.of(context).textTheme.titleMedium,
              suffixIcon: IconButton(
                onPressed: () => passwordVisible.value = !passwordVisible.value,
                icon: Icon(
                  passwordVisible.value
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                ),
              )),
        ),
        const SizedBox(height: 5),
        TextFormField(
          validator: (value) => value != null &&
                  value.length > 7 &&
                  value == passwordController.text
              ? null
              : "Please enter a valid password",
          controller: confirmPasswordController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          obscureText: !confirmPasswordVisible.value,
          decoration: InputDecoration(
              labelText: "Confirmed password",
              labelStyle: Theme.of(context).textTheme.titleMedium,
              suffixIcon: IconButton(
                onPressed: () => confirmPasswordVisible.value =
                    !confirmPasswordVisible.value,
                icon: Icon(
                  confirmPasswordVisible.value
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                ),
              )),
        ),
      ],
    );
  }

  Widget _backButton({
    required BuildContext context,
  }) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 25,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          CupertinoIcons.left_chevron,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisible = useState<bool>(false);
    final confirmPasswordVisible = useState<bool>(false);
    final accepted = useState<bool>(false);

    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final emailController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final passwordController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final confirmPasswordController =
        useTextEditingController.fromValue(TextEditingValue.empty);

    return Scaffold(
      resizeToAvoidBottomInset: MediaQuery.of(context).size.height>700,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          Positioned(
            top: 40,
            left: 20,
            child: _backButton(context: context),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SizedBox(
                height: 550,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0)
                            .copyWith(top: 30),
                        child: Form(
                          key: formKey,
                          child: _formFields(
                            context: context,
                            nameController: nameController,
                            emailController: emailController,
                            passwordController: passwordController,
                            passwordVisible: passwordVisible,
                            confirmPasswordController:
                                confirmPasswordController,
                            confirmPasswordVisible: confirmPasswordVisible,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 30),
                        child: _acceptTermsAndPolicy(
                          context: context,
                          accepted: accepted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 25),
                        child: _signUp(
                          context: context,
                          formKey: formKey,
                          nameController: nameController,
                          emailController: emailController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                          accepted: accepted.value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0).copyWith(top: 0),
                        child: TextButton(
                          onPressed: () => _onSingIn(context),
                          child: Text(
                            "Sign in",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
