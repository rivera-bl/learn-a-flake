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
