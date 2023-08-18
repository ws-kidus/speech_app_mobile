import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:speech/provider/authProviders/signInProvider.dart';
import 'package:speech/ui/auth/signUp.dart';
import 'package:speech/ui/widgets/animatedBackground.dart';
import 'package:speech/ui/widgets/dialogs.dart';
import 'package:speech/ui/widgets/widgets.dart';

class _SignInButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;

  const _SignInButton({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    Key? key,
  }) : super(key: key);

  onSignIn(BuildContext context, WidgetRef ref) async {
    if (formKey.currentState!.validate()) {
      await ref.read(signInStateProvider.notifier).signIn(
            email: emailController.text,
            password: passwordController.text,
            rememberMe: rememberMe,
          );

      final isOk =
          ref.read(signInStateProvider).signInUIState == SignInUIState.OK;

      if (context.mounted) {
        if (isOk) {
          Navigator.pop(context);
        } else {
          final errorMessage = ref.read(signInStateProvider).errorMessage ??
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
    final state = ref.watch(signInStateProvider).signInUIState;

    switch (state) {
      case SignInUIState.LOADING:
        return AppWidgets.loadingAnimation();
      default:
        return CircleAvatar(
          backgroundColor: Colors.deepPurple,
          radius: 30,
          child: IconButton(
            onPressed: () => onSignIn(context, ref),
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

class SignInScreen extends HookConsumerWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  _onForgotPassword(BuildContext context) {}

  _onSingUp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  Widget _signIn({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool rememberMe,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Sign in",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        _SignInButton(
          formKey: formKey,
          emailController: emailController,
          passwordController: passwordController,
          rememberMe: rememberMe,
        ),
      ],
    );
  }

  Widget _rememberMeAndForgotPassword({
    required BuildContext context,
    required ValueNotifier<bool> rememberMe,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: IconButton(
        onPressed: () => rememberMe.value = !rememberMe.value,
        icon: Icon(
          rememberMe.value
              ? Icons.radio_button_checked_outlined
              : Icons.radio_button_off,
        ),
      ),
      title: Text(
        "Remember me",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      trailing: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: () => _onForgotPassword(context),
        child: Text(
          "Forgot password?",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
      ),
    );
  }

  Widget _formFields({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required ValueNotifier<bool> passwordVisible,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontSize: 32,
              ),
        ),
        const SizedBox(height: 50),
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
          validator: (value) => value != null && value.length > 7
              ? null
              : "Please enter a valid password",
          controller: passwordController,
          textInputAction: TextInputAction.done,
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
    final rememberMe = useState<bool>(false);

    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final passwordController =
        useTextEditingController.fromValue(TextEditingValue.empty);

    return Scaffold(
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
                height: 510,
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
                            emailController: emailController,
                            passwordController: passwordController,
                            passwordVisible: passwordVisible,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 30),
                        child: _rememberMeAndForgotPassword(
                          context: context,
                          rememberMe: rememberMe,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 25),
                        child: _signIn(
                          context: context,
                          formKey: formKey,
                          emailController: emailController,
                          passwordController: passwordController,
                          rememberMe: rememberMe.value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0).copyWith(top: 0),
                        child: TextButton(
                          onPressed: () => _onSingUp(context),
                          child: Text(
                            "Sign up",
                            style:
                                Theme.of(context).textTheme.titleSmall!.copyWith(
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
