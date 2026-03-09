-- =========================================================
-- HealthBridge Triad
-- Projeto didático de Programação Logica Usando Prolog
-- Alunos: Gutemberg Matos, João Pedro Campos, Lucas Henrique, Breno Costa
-- =========================================================

% =========================================================
%  REPRESENTAÇÃO DOS USUÁRIOS (FATOS)
% =========================================================

% usuario(Tipo, Id, Nome, Extra).

usuario(paciente, 1, "Ana", none).
usuario(paciente, 4, "Carlos", none).
usuario(paciente, 5, "Maria", none).

usuario(medico, 2, "Dr. João", "Cardiologia").
usuario(medico, 6, "Dra. Paula", "Ortopedia").

usuario(laboratorio, 3, "LabX", none).

% =========================================================
%  RELAÇÃO MÉDICO–PACIENTE
% =========================================================

relacao_medico_paciente(2, 1).
relacao_medico_paciente(2, 4).
relacao_medico_paciente(2, 5).

relacao_medico_paciente(6, 1).

% =========================================================
%  AUTENTICAÇÃO
% =========================================================

senha_correta(paciente, "paciente123").
senha_correta(medico, "medico123").
senha_correta(laboratorio, "lab123").

login(Id, Senha) :-
    usuario(Tipo, Id, _, _),
    senha_correta(Tipo, Senha).

% =========================================================
%  VALIDAÇÃO DE NOME
% =========================================================

nome_valido(Nome) :-
    Nome \= "".

% =========================================================
%  CONTAGEM DE PACIENTES POR MÉDICO
% =========================================================

quantidade_pacientes(MedicoId, Quantidade) :-
    findall(PacienteId,
            relacao_medico_paciente(MedicoId, PacienteId),
            Lista),
    length(Lista, Quantidade).

% =========================================================
%  RANKING DE MÉDICOS (DECRESCENTE)
% =========================================================

medico(Id, Nome, Especialidade) :-
    usuario(medico, Id, Nome, Especialidade).

ranking_medicos(RankingOrdenado) :-
    findall(Quantidade-Nome,
        (
            medico(MedicoId, Nome, _),
            quantidade_pacientes(MedicoId, Quantidade)
        ),
        Lista),
    sort(Lista, Crescente),
    reverse(Crescente, RankingOrdenado).

% =========================================================
%  MÁQUINA DE ESTADOS – EXAME (RECURSIVA)
% =========================================================

transicao(requisitado, agendado).
transicao(agendado, realizado).
transicao(realizado, analisado).

exame(100, requisitado).
exame(101, agendado).

estado_atual(Id, Estado) :-
    exame(Id, Estado).

estado_atual(Id, EstadoFinal) :-
    exame(Id, EstadoInicial),
    alcança(EstadoInicial, EstadoFinal).

alcança(Estado, Estado).

alcança(EstadoAtual, EstadoFinal) :-
    transicao(EstadoAtual, Proximo),
    alcança(Proximo, EstadoFinal).

% =========================================================
%  PROCESSAMENTO EM LOTE
% =========================================================

exames_no_estado(Estado, Lista) :-
    findall(Id, estado_atual(Id, Estado), Lista).

% =========================================================
%  MENU
% =========================================================

:- initialization(main).

main :-
    menu.

menu :-
    repeat,
    nl,
    write('=== HEALTHBRIDGE ==='), nl,
    write('1 - Login'), nl,
    write('2 - Validar Nome'), nl,
    write('3 - Avancar Estado de Exame'), nl,
    write('4 - Listar Exames por Estado'), nl,
    write('5 - Ranking de Medicos (por qtd pacientes)'), nl,
    write('0 - Sair'), nl,
    write('Escolha: '),
    read_line_to_string(user_input, Opcao),
    executar(Opcao),
    Opcao == "0", !.

% =========================
% LOGIN
% =========================

executar("1") :-
    !,
    write('Id do usuario: '),
    read_line_to_string(user_input, IdStr),
    number_string(Id, IdStr),
    write('Senha: '),
    read_line_to_string(user_input, Senha),
    (login(Id, Senha)
        -> write('Login realizado com sucesso!')
        ;  write('Login invalido!')
    ), nl.

% =========================
% VALIDAR NOME
% =========================

executar("2") :-
    !,
    write('Nome: '),
    read_line_to_string(user_input, Nome),
    (nome_valido(Nome)
        -> write('Nome valido!')
        ;  write('Nome invalido!')
    ), nl.

% =========================
% AVANÇAR ESTADO
% =========================

executar("3") :-
    !,
    write('Estado atual (requisitado, agendado, realizado): '),
    read_line_to_string(user_input, EstadoStr),
    atom_string(Estado, EstadoStr),
    (transicao(Estado, Novo)
        -> write('Proximo estado: '), write(Novo)
        ;  write('Nao existe transicao para esse estado')
    ), nl.

% =========================
% LISTAR EXAMES POR ESTADO
% =========================

executar("4") :-
    !,
    write('Digite o estado: '),
    read_line_to_string(user_input, EstadoStr),
    atom_string(Estado, EstadoStr),
    exames_no_estado(Estado, Lista),
    (Lista \= []
        -> write('Exames encontrados: '), write(Lista)
        ;  write('Nenhum exame encontrado nesse estado')
    ), nl.

% =========================
% RANKING REAL DE MÉDICOS
% =========================

executar("5") :-
    !,
    ranking_medicos(Ranking),
    (Ranking \= []
        -> write('Ranking (QtdPacientes-Nome): '), nl,
           imprimir_ranking(Ranking)
        ;  write('Nenhum medico encontrado')
    ), nl.

imprimir_ranking([]).
imprimir_ranking([Qtd-Nome | Resto]) :-
    write(Nome), write(' - '),
    write(Qtd), write(' pacientes'), nl,
    imprimir_ranking(Resto).

executar("0") :-
    write('Encerrando sistema...'), nl.

executar(_) :-
    write('Opcao invalida!'), nl.