# Github Action - Generate CHANGELOG and tag release

This Github Action (simply written in bash) :
- Generates changelog content based on commit messages.
- Push it to the current branch.
- Tag a new release with the content of this release.

## Usage
### Pre-requisites

Your project has to respect two thing to use this action correctly : 
- **Commit message convention :** Currently, the only supported commit convention is the angular one. See [Angular contributing](https://github.com/angular/angular/blob/master/CONTRIBUTING.md) for more informations.
- **Semantic versionning :** At least your last tag has to respect the [Semantic versionning](https://semver.org/) convention, so the tagging system can increment the corresponding number.

### Inputs

- **GITHUB_TOKEN :** A github generated token that will be used to commit/push the updated CHANGELOG.md and the tag
- **GITHUB_USER :** The user linked to the token that will be used to commit/push the updated CHANGELOG.md and the tag


### Outputs
- **NEW_TAG :** This will contain the new created tag, you then are able to make update on it further in your workflow

### Example

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
```

## License
The scripts and documentation in this project are released under the [MIT License](https://github.com/zthulj/changelog-and-tag-action/blob/master/LICENSE)



