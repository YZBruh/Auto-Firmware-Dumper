# Auto Firmware Dumper
It allows you to create ROM dumps using GitHub actions. It uses [DumprX](https://github.com/DumprX/DumprX) when creating dumps.

## Requirements
- ROM Link [mediafire | mega.nz | gdrive | AndroidFileHost OR Directly download link]
- GitHub token (I will explain)
- Patience

## Instruction for use
- Go to the GitHub account settings. Create an access bucket there. Token type should be classic. Mark all the boxes. And copy the token immediately. Because you won't see again
- Fork this repository.
- Go to Settings of the forked repository.
- Then go to Secrets and Variables, and tap Action in dropdown choices.
- Tap New Repository Secrets;
Add this:
`GTOKEN`
`<paste here your token name>`
- Then tap Add Secrets.
- If actions are not enabled, enable them from settings.
- Go to: this repository > Actions > All workflows> Auto Firmware Dumper > Run workflows > Fill in the requested information.
- When the process is completed, you will have the following among your repositories: dump_`<brand>`_`<device>`. And if you've approved it, the repository of device trees you've approved. You will understand when you look.

## Small explanations and notes
- This project is licensed under the `Eclipse Public License 2.0`
- Any deficiencies or problems on the dump are caused by Stock ROM.
- I'm still developing it. But still good.
- If there is a capital letter in the device code name, do not write it that way. Make all letters lowercase.
- Report problems.
- Make sure you fill in the information correctly.
- It is imperative to enter all the desired information.
- Set the action entries to `Okay` for the trees you want to be loaded separately. If you don't want `I do not want`.
- 50MB and over files will be deleted. Reason: go maximum file head installation size 50MB. If that happens more, it will fail.
- Telegram: @YZBruh
