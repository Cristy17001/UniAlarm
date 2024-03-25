class Alarm {
    String disciplina;
    String tipo;
    String turma;
    String sala;
    String professor;
    int index;
    int duracao;
    String inicio;
    late String dia;

    Alarm.new(String disciplina, String tipo, String turma, String sala, String professor, int index, int duracao, String inicio)
        : disciplina = disciplina,
          tipo = tipo,
          turma = turma,
          sala = sala,
          professor = professor,
          index = index,
          duracao = duracao,
          inicio = inicio {
      switch (index) {
        case 0:
          dia = "Segunda-Feira";
          break;
        case 1:
          dia = "Terça-Feira";
          break;
        case 2:
          dia = "Quarta-Feira";
          break;
        case 3:
          dia = "Quinta-Feira";
          break;
        case 4:
          dia = "Sexta-Feira";
          break;
        case 5:
          dia = "Sabado";
          break;
        default:
          dia = "";
      }
    }

    void draw() {
      print("----------------------------------------------------------");
      print("Na $dia");
      print("Tens uma aula $tipo");
      print("Da disciplina de $disciplina");
      print("Na sala $sala");
      print("Com a turma $turma");
      print("O teu professor tem a sigla $professor");
      print("Vai ter uma duração de $duracao minutos e começa às $inicio!");
      print("----------------------------------------------------------");
      print("");
    }

  }