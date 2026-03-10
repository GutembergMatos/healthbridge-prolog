# Documento descritivo do sistema HealthBridgeTriad - Fase Lógica

**Disciplina:** Paradigmas de Linguagens de Programação - UFCG
**Projeto:** HealthBridge Triad  
**Alunos:** Gutemberg Matos, João Pedro Campos, Lucas Henrique, Breno Costa

---

## 1. Membros e suas atividades - Fase Lógica

Gutemberg Matos foi responsável pelo desenvolvimento e aplicação dos conceitos estudados em sala de aula para criar o sistema HealthBrige Triad.
João Pedro Campos e Breno Costa foram responsáveis por gravar, editar e finalizar a apresentação em vídeo acerca do projeto em sua fase lógica.
Lucas Henrique foi responsável por escrever este documento explicando como cada conceito aprendido foi aplicado em nosso projeto em sua fase lógica.
Além disso, Breno Costa, João Pedro Campos e Lucas Henrique foram também responsáveis pela revisão do código.

## 2. Sobre o projeto - Fase Lógica

Como no primeiro documento, o projeto _HealthBridge Triad_ foi desenvolvido com o objetivo de demonstrar, de forma prática, a aplicação dos principais conceitos aprendidos em sala de aula sobre o paradigma lógico, utilizando a linguagem Prolog.

---

## 3. Fatos em Prolog

Um dos princípios centrais de Prolog são os **fatos**. Em prolog, `fatos` representam, como diz o nome, fatos ou verdades do sistema. No nosso código, esses fatos podem ser vistos, por exemplo, em:
```
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
```

Essas afirmações são, geralmente, úteis para futuras consultas, como acontece no HealthBridgeTriad, atuando como um tipo de "base" de conhecimentos para o sistema.


---

## 4. Relações em Prolog

Em seguida, no código, já nos deparamos com ``relações`` em Prolog.
```
% =========================================================
%  RELAÇÃO MÉDICO–PACIENTE
% =========================================================

relacao_medico_paciente(2, 1).
relacao_medico_paciente(2, 4).
relacao_medico_paciente(2, 5).

relacao_medico_paciente(6, 1).
```

``relações`` são semelhantes à ``fatos``, exprimindo quais afirmações são verdadeiras, mas entre diferentes elementos de conjuntos, bem semelhante à representação matemática de relações entre elementos e conjuntos.


---

## 5. Regras em Prolog

Regras em Prolog atuam com base em inferência lógica, e explicitam bem a natureza de Prolog baseada em Lógica de Predicados. No projeto, vemos a primeira demonstração de uma ``regra`` 
em
```

login(Id, Senha) :-
    usuario(Tipo, Id, _, _),
    senha_correta(Tipo, Senha).
```

A maneira que a ``regra`` funciona em Prolog é como uma definição de um conjunto. ``login(Id, Senha)`` é válido/verdade se um ``usuário`` de id ``Id`` e de tipo ``Tipo`` existir e uma ``senha_correta`` para uma senha ``Senha`` existir para o mesmo tipo ``Tipo`` de usuário. Diferente do que vemos comumente na programação, por Prolog ser um paradigma lógico, podemos ver a regra ``login(Id, Senha)`` da mesma forma que veríamos uma função matemática aonde queremos encontrar um conjunto de soluções para algum ``x, y, z, ..., n`` passado.

Por exemplo, para ``login(2, "medico123")`` a regra seria verdadeira, pois:
``usuario(Tipo, 2, _, _) => Tipo = medico (ou seja, existe/verdadeiro)``
``senha_correta(medico, "medico123") => Verdade``
Da mesma forma, poderíamos obter um conjunto de soluções para ``login(2, X) => "medico123"``
Existem várias outras definições de regras além dessa no projeto, que serão exploradas mais à frente no documento.



---

## 6. Unificação em Prolog

**Unificação** é um dos conceitos mais importantes de Prolog, e afeta justamente o que foi descrito anteriormente na regra ``login``. Unificar, em Prolog, é o processo que permite a criação dos conjuntos de solução para o que "perguntamos" para o sistema. Ao unificar, Prolog tenta substituir as variáveis passadas, com base nos ``fatos`` que tem disponível, ``relações`` e ``regras``, através de consultas aos mesmos. É na unificação também que ocorre a propagação dos valores das variáveis, conceito que será explorado na seção de **Backtracking**. Prolog tenta **unificar** até as condições da regras estarem satisfeitas, ou não ser mais possível explorar possibilidades.



---

## 7. Backtracking em Prolog

**Backtracking** atua diretamente na **unificação** de Prolog, e funciona baseado no sistema de explorar possibilidades presente. Quando uma solução é obtida, dependendo da maneira que foi "chamado" a unificação, o sistema pode ``PARAR`` ou ``BUSCAR MAIS SOLUÇÕES``. Um exemplo disso no nosso código é quando utilizamos ``findall``
```
ranking_medicos(RankingOrdenado) :-
    findall(Quantidade-Nome,
        (
            medico(MedicoId, Nome, _),
            quantidade_pacientes(MedicoId, Quantidade)
        ),
        Lista),
    sort(Lista, Crescente),
    reverse(Crescente, RankingOrdenado).
```

Aqui, ``findall`` busca por todas as soluções possíveis do par ``Quantidade-Nome``, "armazena" cada solução em ``Lista``. Veja, caso não houvesse **backtracking**, após o sistema encontrar uma solução, ele não saberia qual a próxima possibilidade para explorar, ou até mesmo só pararia.


---

## 8. Recursão em Prolog

**Recursão** em Prolog é extremamente útil, e relativamente abstrato à primeira vista. Na **recursão**, chamamos a mesma ``regra`` dentro de si mesma, e temos uma forma de "guarda" ou um "caso base" para que essa ``regra`` pare.
No nosso código, **recursão** pode ser vista em:
```
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
```

Aonde ``alcança`` faz uso da **recursão** para descobrir se estado ``EstadoAtual`` alcança o estado final ``EstadoFinal`` passado, ou, **quais** ``EstadoFinal`` podem ser alcançados por aquele ``EstadoAtual`` ou ainda quais ``EstadoAtual`` podem alcançar aquele ``EstadoFinal`` (``alcança(requisitado, agendado), alcança(requisitado, X), alcança(X, analisado))
Note também que existem **duas** "definições" para as regras ``alcança`` e ``estado_atual``. Essa definições são importantes, pois além de cobrirem casos diferentes, mas que devem estar na mesma regra, ainda servem como "caso base" para parar a **recursão**.

Vamos explorar um caso de ``estado_atual`` para observar a **recursão** em ação.
```
estado_atual(100, X)
	exame(100, EstadoInicial) => EstadoInicial = requisitado
	alcança(requisitado, X)
		alcança(requisitado, X) => X = requisitado (fato alcança(Estado, Estado).)
		(supondo que usamos uma consulta com backtracking)
		Há mais possibilidades?
		alcança(requisitado, X)
			transicao(requisitado, Proximo) => Proximo = agendado
			alcança(agendado, X)
				alcança(agendado, X) => X = agendado (fato alcança(Estado, Estado).)
				
		... e assim segue, até não encontrar mais soluções
```

---

## 9. Interação com o usuário

No fim, foi feito um ``menu`` que possibilita ao usuário interagir com o sistema, utilizando das regras criadas (e criando outras) para realizar consultas, logar o usuário, listar exames e ranquear os médicos diretamente pelo terminal.


