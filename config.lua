Config = {}

-- [ Identidade e Permissões ]
Config.Command = "safezone"          -- Nome do comando para abrir o painel (Padrão: criarsafe)
Config.Permission = "admin.permissao" -- Permissão vRP necessária para abrir o painel e gerenciar

-- [ Limites de Criação ]
Config.MaxPoints = 30                 -- Quantidade máxima de pontos (máximo 20 recomendado por estética)

-- [ Configurações de Notificação ]
Config.NotifyOnEnter = true           -- Ativar notificação ao entrar na safezone
Config.NotifyOnExit = true            -- Ativar notificação ao sair da safezone

-- [ Permissões de Gerenciamento ]
-- Ative ou desative as funções que aparecem no painel administrativo
Config.AllowRename = true             -- Poder alterar o nome das safezones existentes
Config.AllowDelete = true             -- Poder excluir safezones existentes
Config.AllowTeleport = true           -- Poder teleportar para as safezones
