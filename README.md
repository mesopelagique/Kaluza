# Kaluza

Add a fifth dimension to your project by installing github components.

## Usage

Use one of the following methods to download 4d component base into your current `Components` folder.

### From configuration file

Create a `component.json` file at your database root folder.

💡 You can use [kaluza command line application](https://github.com/mesopelagique/kaluza-cli) to do that or see file content  in [From file section](#From-file)

If Kaluza is installed and your database accept to send on start event to other components, the components dependencies will be installed at start.

### By code

#### Install a github component by code

```4d
$result:=install_github ("mesopelagique/CollectionUtils")
```

##### with options

```4d
$result:=install_github ("mesopelagique/CollectionUtils";New object("binary";False))
```

|name|descriptions|default|
|-|-|-|
|binary| Use binary or not ie. 4DZ compiled file |`True`|

#### From object definition

```4d
$kaluza:=cs.Kaluza.new()
$kaluza.options:=New object("binary";False)
$kaluza.dependencies:=New collection("mesopelagique/CollectionUtils";"mesopelagique/ObjectClassMapper")

$result:=$kaluza.installDependencies()
```

#### From file 

```4d
cs.Kaluza.new(Folder(fk database folder).file("component.json")).installDependencies()
```

with files containing the dependencies

```json
{
  "name": "Name of my component",
  "dependencies": [
    "mesopelagique/CollectionUtils",
    "mesopelagique/ObjectClassMapper"
  ]
}
```

## TODO

- [X] CLI app https://github.com/mesopelagique/kaluza-cli
- [ ] Support specific version
- [ ] Recursive dependencies

## Why Kaluza?

> In physics, Kaluza–Klein theory (KK theory) is a classical unified field theory of gravitation and electromagnetism built around the idea of a fifth dimension beyond the usual four of space and time and considered an important precursor to string theory.
[@Wikipedia](https://en.wikipedia.org/wiki/Kaluza%E2%80%93Klein_theory)

![Illustation](http://www.thephysicsmill.com/blog/wp-content/uploads/antsonbridge.jpg)
