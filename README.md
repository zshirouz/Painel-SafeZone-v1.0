# 🛡️ shirouz_safezone

**shirouz_safezone** é um sistema de Safezone (Zona Segura) profissional, altamente otimizado e visual para servidores FiveM utilizando o framework **vRP**. Diferente de sistemas básicos baseados em raios circulares, este script permite a criação de zonas poligonais complexas com ferramentas visuais in-game.

---

## 🚀 Funcionalidades Principais

- 📐 **Criação Poligonal**: Crie safezones com qualquer formato (não apenas círculos) utilizando pontos de marcação visual.
- 🎨 **Ferramenta Visual In-game**: Sistema intuitivo para definir os limites da zona enquanto caminha pelo mapa.
- 🖥️ **Painel de Gerenciamento NUI**: Painel moderno para listar, renomear, deletar e teleportar para as safezones existentes.
- ⚡ **Alta Performance**: Utiliza cache no servidor e verificações de distância otimizadas no cliente (Ray Casting eficiente).
- 🛡️ **Proteção Completa Automatizada**:
  *   Desativa o disparo de armas.
  *   Guarda armas automaticamente (Unarmed).
  *   Invencibilidade (Godmode) enquanto dentro da zona.
  *   Desativa Friendly Fire (Fogo Amigo).
- 🔔 **Notificações**: Avisos configuráveis ao entrar e sair de cada zona.

---

## 🛠️ Configuração

O arquivo `config.lua` permite personalizar o comportamento básico do script:

```lua
Config = {}

-- [ Identidade e Permissões ]
Config.Command = "safezone"          -- Comando para abrir o painel
Config.Permission = "admin.permissao" -- Permissão vRP para gerenciar

-- [ Limites de Criação ]
Config.MaxPoints = 30                 -- Máximo de pontos por polígono

-- [ Notificações ]
Config.NotifyOnEnter = true           -- Notificar ao entrar
Config.NotifyOnExit = true            -- Notificar ao sair

-- [ Funções Disponíveis no Painel ]
Config.AllowRename = true             -- Permitir renomear
Config.AllowDelete = true             -- Permitir excluir
Config.AllowTeleport = true           -- Permitir teleportar
```

---

## 🎮 Comandos (Admin)

-   `/safezone`: Abre a interface de criação e o painel de gerenciamento das zonas existentes.

---

## 📖 Como criar uma Safezone?

1.  Digite `/safezone` (ou o comando configurado).
2.  Use a tecla **[E]** para adicionar pontos no chão onde você está pisando.
3.  Observe as linhas conectando os pontos para formar o polígono.
4.  Use o **Botão Esquerdo do Mouse** para finalizar e salvar (mínimo 3 pontos).
5.  Dê um nome à zona no modal que aparecerá.
6.  **Teclas Úteis**:
    *   `[L]`: Alterna entre controlar o Cursor e a sua Movimentação.
    *   `[Botão Direito]`: Remove o último ponto colocado.
    *   `[ESC]`: Cancela a criação.

---

## 📄 Créditos

Desenvolvido por **ShirouZ**.
