<a id="readme-top"></a>

![GitHub License](https://img.shields.io/github/license/extension-inspector/extension-inspector?style=for-the-badge)
![GitHub Commits](https://img.shields.io/github/last-commit/extension-inspector/extension-inspector.svg?style=for-the-badge)
![GitHub Issues](https://img.shields.io/github/issues-raw/extension-inspector/extension-inspector.svg?style=for-the-badge)

<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/ei-logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Extension Inspector</h3>

  <p align="center">
    Get the big picture of your S/4HANA system - gain control, clarity, and actionable insights.
    <br />
    <br />
    <a href="https://github.com/extension-inspector/extension-inspector/issues/new?labels=bug">Report Bug</a>
    &middot;
    <a href="https://github.com/extension-inspector/extension-inspector/issues/new?labels=enhancement">Request Feature</a>
  </p>
</div>
<br />

> [!WARNING]  
> This project is currently under **very active** development. Expect bugs and breaking changes.

<br />

## About The Project
<img src="images/ei-screenshots.png" title="Screenshots">
<br />
<br />
Text about the project

<br />

## Prerequisits
_Minimum requirements to make use of this tool._
- S/4HANA on-premise or private cloud edition at least in release 2022
- Application Jobs must be enabled and configured
- [ABAPGit](https://github.com/abapGit/abapGit) must be available on your system for the inital setup

<br />

## Getting Started
_Follow the instructions below to get started with the app on your own S/4HANA System._

### Creation of the Backend
1. Create a local packge in your S/4HANA system
2. Clone this repository into the package via [ABAPGit](https://github.com/abapGit/abapGit)
3. Open transaction `/iwfnd/v4_admin` and publish the odata service `ZEI_UI_O4`

### Deployment of the Frontend
1. Open VSCode and clone this repository
2. Change the directory to `frontend` and install all modules
   ```sh
   npm i
   ```
3. Create a `ui5-deploy.yaml`
   ```js
   npm run deploy-config
   ```
4. Deploy the app to your S/4HANA system
   ```sh
   npm run deploy
   ```
5. Done! Now you can open the app standalone by selecting _right click --> Test_ on the deployed BSP file or by adding the app to your Fiori Launchpad (App ID `com.extension-inspector.extension-inspector`).

### Creating Object Caches
_Generating the caches is necessary for the app to be able to show diagrams and understand links between different development objects._
1. Open the Standard App 'Application Jobs' (F1240)
2. Create a one-time or scheduled job based on the job template `ZEI_REFRESH_OBJECTCACHE_JT`

<br />

## Third Party Libraries in this Project

![test](https://avatars.githubusercontent.com/u/57169982?s=15&v=4) [mermaid](https://github.com/mermaid-js/mermaid)
&middot;
![test](https://avatars.githubusercontent.com/u/225407?s=15&v=4) [panzoom](https://github.com/anvaka/panzoom)

<p align="right">(<a href="#readme-top">back to top</a>)</p>