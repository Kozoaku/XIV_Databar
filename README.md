# XIV_Databar

## About
XIV_Databar is a simple to use data text display bar. It replaces some UI elements, such as the micro menu, and adds quick access to things like loot spec, spec changes and hearths. It is unobtrusive and can be anchored to any side of the screen. It also integrates into ElvUI for proper skinning of bar elements.

Developed with a plugin system in mind, it is easy to get started adding a new data text to the bar. Simply call `XIV_Databar:NewPlugin()` to create a new plugin and have access to the Plugin API. This will manage registering your plugin with the main bar, provide hooks for placing your data text and manage tooltips. For more information, see [Plugin API](docs/PluginAPI.md) for more details on creating a plugin.

## Download
XIV_Databar is available to download directly from [Wago](https://addons.wago.io/addons/xiv-databar) and [GitHub Releases](https://github.com/Kozoaku/XIV_Databar/releases). If you prefer to utilize an addon updater, it should be available if the updater utilizes one of these sources.

If you are looking for an addon updater, I suggest [WoWUp](https://wowup.io) since it pulls from its own database of addons, TukUI, WowInterface, GitHub Releases, Wago[^1] and Curseforge[^1]. It manages all clients and PTR versions of WoW seperatly and doesn't collect PII or system information. 

[^1]: Requires an ad supported version of the updater.

## Requests, Bugs, Comments

Any issues, feature requests or suggestions should be made [here](https://github.com/Kozoaku/XIV_Databar/issues). Each issue will be triaged and put into a milestone based on priority. Milestones correspond to either bug fix releases, feature releases or major version releases. If you get a lua error, please disable all other addons (except !BugGrabber & BugSack if you run them) and replaicate the error. This helps determine where in this addon the issue occured.


## Contributing

If you wish to contribute to the project, please fork and submit a pull request. The project uses [Semantic Release](https://semantic-release.gitbook.io/semantic-release/) to parse commit messages and generate a semantic version number. Any PR's opened should follow the format expected by Semantic Release.

I am not very active in game, but I will give any contributions the same care and 
attention you did. Please note, you will need to copy the Libs folder from the most 
recent release into your development version since they are not included in the repo.
