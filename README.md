# Kaluza

Add a fifth dimension to your project by installing github components.

## Usage

Use of the following methods to download 4d component base into your current `Components` folder.

### Install a github component by code

```4d
$result:=install_github ("mesopelagique/CollectionUtils")
```

#### with options

```4d
$result:=install_github ("mesopelagique/CollectionUtils";New object("binary";False;"submodule";True))
```

|name|descriptions|default|
|-|-|-|
|binary| Use binary or not ie. 4DZ compiled file |`True`|

### From object definition

```4d
$kaluza:=cs.Kaluza.new()
$kaluza.options:=New object("binary";False;"submodule";True)
$kaluza.dependencies:=New collection("mesopelagique/CollectionUtils";"mesopelagique/ObjectClassMapper")

$result:=$kaluza.installDependencies()
```

## Why Kaluza?

> In physics, Kaluza–Klein theory (KK theory) is a classical unified field theory of gravitation and electromagnetism built around the idea of a fifth dimension beyond the usual four of space and time and considered an important precursor to string theory.
[@Wikipedia](https://en.wikipedia.org/wiki/Kaluza%E2%80%93Klein_theory)

![Illustation](http://www.thephysicsmill.com/blog/wp-content/uploads/antsonbridge.jpg)
