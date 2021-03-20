
#  :rocket: Generate CHANGELOG  and TAG  :newspaper: :bookmark:
  <a href="https://twitter.com/JeremyThulliez" target="_blank">
    <img alt="Twitter: grzi" src="https://img.shields.io/twitter/follow/grzi.svg?style=social" /></a>
  

This **Github Action** (simply written in bash to be as light as possible) :
- Generates a changelog, based on commit messages and a commit message convention.
- Push it to the current branch.
- Tag a new release with the content of this release.

## Usage 
### :warning:  Pre-requisites 

Your project has to respect two thing to use this action correctly : 
- **Commit message convention :** Currently, the only supported commit convention is the angular one. See [Angular contributing](https://github.com/angular/angular/blob/master/CONTRIBUTING.md) for more informations.
- **Semantic versionning :** At least your last tag has to respect the [Semantic versionning](https://semver.org/) convention, so the tagging system can increment the corresponding number.

###  :arrow_heading_down: Inputs 

There is two **mandatory** env variables to set :

- **GITHUB_TOKEN :** Oauth2 token that will be used to push changes to the repository.
- **GITHUB_USER :** The user associated with the oauth2 token.

And some **optionnals** so as to customise the action :
- **LOG_LEVEL :** The level of log you want to display in your task. (**1**, **2** [default] or **3**)


### :arrow_heading_up: Outputs 
- **NEW_TAG :** This will contain the new created tag (ex : 1.0.0)

###  :eyes: Example 

Example of workflow.yml :

```yaml
name: Java CI

on: 
  push:
    branches:
    - master
    paths-ignore:
    - 'CHANGELOG.md'

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1
    - name: Generate changelog
      uses: zthulj/changelog-and-tag-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        GITHUB_USER: user
        LOG_LEVEL: 1
```
## :bust_in_silhouette:  Author

**Jérémy Thulliez**

* Twitter: [@zthulj](https://twitter.com/zthulj)
* Github: [@zthulj](https://github.com/zthulj)

## 🤝 Contributing
Contributions, issues and feature requests are welcome!<br/>Feel free to check [issues page](https://github.com/zthulj/changelog-and-tag-action/issues).

Thanks to all our [contributors](https://github.com/zthulj/changelog-and-tag-action/graphs/contributors) !

## :notebook: License
The scripts and documentation in this project are released under the [MIT License](https://github.com/zthulj/changelog-and-tag-action/blob/master/LICENSE)