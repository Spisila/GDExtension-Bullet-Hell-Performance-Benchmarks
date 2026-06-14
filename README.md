# Godot C++ GDExtension — Bullet Hell

Este repositório contém um projeto Godot 4 que utiliza uma extensão escrita em C++ (GDExtension) para gerenciar balas e lógica de entidades.

## Visão geral

O projeto inclui o código do jogo em `cpp-bullet-hell/` e a extensão C++ em `extension_src/`. As instruções abaixo mostram como preparar o ambiente e compilar a extensão no Windows.

## Pré-requisitos (Windows)

- **Godot 4.x** (versão compatível com GDExtensions)
- **Visual Studio 2019/2022** com workload "Desktop development with C++" (toolset MSVC)
- **Python 3.8+** (para SCons)
- **SCons** (construtor usado pelo `SConstruct` no projeto)
- **Git**
- **CMake** e **Ninja** (opcionais, caso opte por builds via CMake)

Observação: você poderá usar PowerShell ou o Developer Command Prompt for Visual Studio (recomendado para ter as variáveis de ambiente MSVC corretas).

## Passo a passo de instalação (Windows)

1. Clone o repositório (se ainda não tiver):

```powershell
git clone <URL_DO_REPOSITORIO>
cd Godot-CPP-BulletHell
```

2. Crie e ative um ambiente virtual Python (opcional, recomendado):

```powershell
python -m venv .venv
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.\.venv\Scripts\Activate.ps1
```

3. Instale o SCons (no ambiente Python ativo):

```powershell
python -m pip install --upgrade pip
pip install scons
```

4. Configure o ambiente de compilação MSVC

- Abra o `Developer Command Prompt for Visual Studio` ou ative as variáveis MSVC no PowerShell (ex.: use o prompt do Visual Studio) para garantir que o compilador e ferramentas de link estejam no PATH.

5. Build da GDExtension

- A partir da raiz do projeto (`Godot-CPP-BulletHell`), execute o SCons com a target para Windows. O workspace já tem uma task configurada equivalente a este comando:

```powershell
scons platform=windows target=template_debug dev_build=yes -j8
```

- O artefato gerado normalmente ficará em `build/bin/` ou `bin/`. Após o build bem-sucedido você deverá ver um arquivo `.gdextension` (por exemplo `bullet_manager.gdextension`).

6. Copiar/instalar a extensão no jogo

- Se necessário, copie o arquivo `.gdextension` e arquivos associados para a pasta do projeto Godot (ex.: `cpp-bullet-hell/bin/`). O projeto Godot do repositório já referencia as entradas esperadas.

7. Abrir o projeto no Godot

- Abra o Godot e selecione a pasta `cpp-bullet-hell/` como o projeto, ou execute via linha de comando (ajuste o caminho para seu executável Godot):

```powershell
godot --path cpp-bullet-hell
```

## Problemas comuns

- "Compilador não encontrado / erros MSVC": abra o Developer Command Prompt for Visual Studio para garantir as variáveis de ambiente ou instale o workload C++ no Visual Studio Installer.
- "SCons não encontrado": confirme que o `pip install scons` foi executado no mesmo Python/venv que você está usando.
- Erros de ABI/headers Godot: verifique se a versão do `godot-cpp`/headers é compatível com a versão do Godot que você está usando.

## Dicas úteis

- Para builds de release, ajuste `target=template_release` ou a configuração equivalente no `SConstruct`.
- Se preferir builds via CMake (algumas ferramentas do `godot-cpp` usam CMake), confirme os diretórios em `extension_src/godot-cpp/` e siga as instruções desse subdiretório.

## Estrutura principal do repositório

- `cpp-bullet-hell/` — projeto Godot com cenas, scripts e assets
- `extension_src/` — código-fonte da extensão C++ (`SConstruct`, fontes, bindings)
- `build/` — diretório de build gerado (padrão)
- `bin/` — saída da extensão (pode conter `*.gdextension`)
