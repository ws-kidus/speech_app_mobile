import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/provider/userProvider.dart';
import 'package:speech/ui/widgets/dialogs.dart';
import 'package:speech/ui/widgets/widgets.dart';

class ProfileSetting extends HookConsumerWidget {
  const ProfileSetting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider).user.first;
    return Scaffold(
      appBar: AppWidgets.appBar(context: context, title: user.name),
      body: Column(
        children: [
          _Tile(
            onUpdate: (String text) async {
              final response =
                  await ref.read(userStateProvider.notifier).changeUserDetails(
                        name: text,
                      );
              if (!response && context.mounted) {
                Dialogs.toast(
                  context: context,
                  message: "There seems to be a problem",
                  buttonText: "Close",
                );
              }
            },
            label: "Name",
            hintText: "Edit your name",
            value: user.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return true;
              }
              return false;
            },
            errorText: "please enter your name",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.text,
          ),
          ListTile(
            leading: Text(
              "Email:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            title: Text(
              user.email,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _Tile(
            onUpdate: (String text) async {
              final response =
                  await ref.read(userStateProvider.notifier).changeUserDetails(
                        phone: text,
                      );
              if (!response && context.mounted) {
                Dialogs.toast(
                  context: context,
                  message: "There seems to be a problem",
                  buttonText: "Close",
                );
              }
            },
            label: "Phone",
            hintText: "Enter your phone",
            value: user.phone ?? "",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return true;
              }
              return false;
            },
            errorText: "please enter your phone number",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class _Tile extends HookConsumerWidget {
  final String label;
  final String hintText;
  final String value;
  final bool Function(String? value) validator;
  final String errorText;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final void Function(String text) onUpdate;

  const _Tile({
    Key? key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.validator,
    required this.errorText,
    required this.textInputAction,
    required this.textInputType,
    required this.onUpdate,
  }) : super(key: key);

  _onCancel(ValueNotifier<bool> edit) {
    edit.value = false;
  }

  _onEdit(ValueNotifier<bool> edit) {
    edit.value = true;
  }

  Widget _textFiled({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required ValueNotifier<bool> edit,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        validator: (value) {
          final result = validator(value);
          if (result) {
            return errorText;
          }
          return null;
        },
        style: Theme.of(context).textTheme.titleMedium,
        controller: controller,
        autofocus: true,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
            ).copyWith(left: 8),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.titleMedium,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.pink),
              borderRadius: BorderRadius.circular(10),
            ),
            prefix: Text(
              "$label: ",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            suffix: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _onCancel(edit);
                      onUpdate(controller.text);
                    },
                    icon: const Icon(
                      CupertinoIcons.check_mark,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _onCancel(edit),
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = useState<bool>(false);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final controller =
        useTextEditingController.fromValue(TextEditingValue.empty);

    controller.text = value;

    if (edit.value) {
      return Form(
        key: formKey,
        child: _textFiled(
          context: context,
          controller: controller,
          label: label,
          edit: edit,
        ),
      );
    } else {
      return ListTile(
        leading: Text(
          "$label:",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        title: Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: IconButton(
          onPressed: () => _onEdit(edit),
          icon: Icon(Icons.edit),
        ),
      );
    }
  }
}
