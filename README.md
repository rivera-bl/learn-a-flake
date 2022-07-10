## First Flake

Leaving this here to diff a `flake` without/with `flake-utils`

`nix flake new -t templates#go-hello .`

## dockerTools.buildLayeredImage {}

should add docker to `configuration.nix`, in the meanwhile:

```
nix build .#docker
nix-shell -p docker
sudo dockerd &
sudo docker load < result
sudo docker run go-hello:<tag>
```

## direnv

check for the setup needed for your `shell` [here](https://direnv.net/docs/hook.html)

```
nix profile install nixpkgs#direnv
echo "use flake" >> .envrc && direnv allow
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc
```

## NixOS VM with Vagrant

For ease of experimentation use a NixOS VM with Vagrant. Build the box:

```
git clone https://github.com/nix-community/nixbox
cd nixbox
packer build --only=virtualbox-iso nixos-x86_64.json
vagrant box add nixbox-21.05 nixos-21.05-virtualbox-x86_64.box
vagrant init nixbox-21.05
vagrant up
vagrant ssh
```

- The box is at vagrant cloud `dusk/nixos`. I uploaded it manually following [this](https://blog.ycshao.com/2017/09/16/how-to-upload-vagrant-box-to-vagrant-cloud/), although there should be an automated way using post-processors/cli.
- `make update` which is supposed to update the iso_url to the latest, throws a ruby error, and changing the iso_url manually throws an ssh error. So I'll stick to the `21.05` box for now. Nonetheless we can [follow this](https://nixos.org/manual/nixos/stable/index.html#sec-upgrading) to update the `nixos-channel` manually to upgrade to `22.05`. Be sure to run the commands as `root`.

```
sudo su
nix-channel --list | grep nixos
nix-channel --add https://nixos.org/channels/nixos-22.05 nixos
nix-channel --update nixos; nixos-rebuild switch
```

## Resources

- [Practical Nix Flakes][1]
- [How to make your own templates][2]
- [Xe blogpost][3]
- [Xe example 1][4]
- [Xe example 2][5]
- [Flake-utils repo][6]
- [Docker examples][7]

[1]: https://serokell.io/blog/practical-nix-flakes
[2]: https://peppe.rs/posts/novice_nix:_flake_templates/
[3]: https://xeiaso.net/blog/nix-flakes-1-2022-02-21
[4]: https://tulpa.dev/Xe/mara/src/branch/main/flake.nix
[5]: https://github.com/Xe/templates/blob/main/go-web-server/flake.nix
[6]: https://github.com/numtide/flake-utils
[7]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/docker/examples.nix
