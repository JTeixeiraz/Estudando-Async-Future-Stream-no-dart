import 'dart:async';
import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  bool sair = false;
  while (!sair) {
    print('=====hub de exercicios=====');
    print('Selecione qual atividade deseja navegar:');
    print('1. atividade 1');
    print('2. atividade 2');
    print('3. atividade 3');
    print('4. sair');
    String escolha = stdin.readLineSync()??'';
    switch (escolha) {
      case '1':
        mainAtvd1();
        break;
      case '2':
        mainAtvd2();
        break;
      case '3':
        mainAtvd3();
        break;
      case '4':
        sair=true;
        break;
      default:
    }
  }
}

Future<void> mainAtvd1(){
/* 
Exercício 1: Trabalhando com Futures

// Complete o código abaixo conforme instruções

Future<String> buscarDadosWeb(String url) async {
  // Implemente esta função que:
  // - Simula um atraso de rede de 1-3 segundos 
  // - Retorna "Dados da $url" se a url contiver "dart"
  // - Lança uma exceção caso contrário
}

void main() async {
  // 1. Chame buscarDadosWeb com then/catchError
  
  // 2. Chame buscarDadosWeb com await/try-catch
  
  // 3. Use Future.wait para buscar 3 URLs em paralelo
}
*/
return Future.delayed(Duration(seconds: 2),(){
  print('== Buscar dados da web ==');
  print('Digite a URL');
  String url = stdin.readLineSync()??"";
  Future resultado = buscarDadosWeb(url);
  print('url: $resultado');
  throw Exception('algo inesperado ocorreu');
}).then((_){
  print('sucesso no then');
}).catchError((erro){
  print('Erro capturado: $erro');
});
}

Future<String> buscarDadosWeb(String url)async{
  await Future.delayed(Duration(seconds: 3));
  if (url == "dart") {
    return url;
  }else{
    return "vazio";
  }
}

void mainAtvd2() async{
/*
Exercício 2: Trabalhando com Streams
import 'dart:async';

// Implemente esta Stream que emite eventos:
// - Números de 1 a N, com intervalo de 0.5s
// - Ao chegar em N/2 (arredondado), emite um erro
// - Depois continua até N
Stream<int> geradorComErro(int n) async* {
  // Implemente aqui
}

void main() async {
  // 1. Consuma a stream com listen, tratando dados, erro e conclusão
  
  // 2. Consuma com await-for e try-catch
  
  // 3. Transforme a stream para:
  //    - Dobrar os valores
  //    - Filtrar apenas pares
  //    - Pegar os 3 primeiros
}

*/

  int n = 10;
  print('=== 1.Utilizando o Listen ===');
  geradorComErro(n).listen(
    (data) => print('Dado: $data'),
    onError: (error) => print('Erro capturado: $error'),
    onDone: () => print('Stream concluída'),
  );

  print('\n ===2. utilizando await-for e try-cath ===');
  try {
    await for (final int valor in geradorComErro(n)){
      print('recebido $valor');
    }
    print('Stream concluida com sucesso');
  } catch (e) {
    print('erro capturado $e');
  }

  print('\n === 3. Transformando a stream ===');

  final streamTransformada = geradorComErro(n).handleError((error){
    print('Erro tratado na transformação: $error');
  }).map((valor) => valor*2).where((valor) => valor%2 ==0).take(3);

  print('Valores após transformação:');
  await for (final valor in streamTransformada){
    print('Transformado: $valor');
  }
}

Stream<int> geradorComErro(int n) async*{
  for (var i = 1; i <=n; i++) {
    await Future.delayed(Duration(milliseconds: 500));

    if(i == (n/2).round()){
      throw 'Erro ao chegar na metade da sequência (${(n/2).round()})';
    }
    yield i;
  }
}


void mainAtvd3() async{
/*
Exercício 3: Aplicação Prática
// Implemente um monitor de tarefas que:
// 1. Simule 5 tarefas com durações aleatórias (1-5s)
// 2. Use Stream para emitir o progresso (%)
// 3. Mostre mensagens quando cada tarefa completar
// 4. Ao final, mostre o tempo total

void main() async {
  // Implemente sua solução aqui
}

*/
print('Monitoramento de tarefas');

final random = Random();
final tarefas = List.generate(
  5, (index)=>Tarefa(index+1, random.nextInt(5)+1));

  print('Tarefas geradas:');
  for(final tarefa in tarefas){
    print('Tarefa ${tarefa.id}: duração prevista de ${tarefa.duracaototal}s');
  }

  final tempoTotal = await executarTarefas(tarefas);

  print('Todas as tarefas concluídas');
  print('Tempo total de execução ${tempoTotal.inMilliseconds/1000} segundos');

}

class Tarefa{
  final int id;
  final int duracaototal;

  Tarefa(this.id, this.duracaototal);

  Stream<Progresso> executar() async*{
    final stopWatch = Stopwatch()..start();
    
    for(int progresso = 10; progresso <= 100; progresso += 10){
      final tempoAlvo = (duracaototal*1000*progresso/100).round();
      final tempoAtual = stopWatch.elapsedMicroseconds;
      if(tempoAtual<tempoAlvo){
        await Future.delayed(Duration(milliseconds: tempoAlvo - tempoAtual));
      }

      yield Progresso(id, progresso, stopWatch.elapsed);
    }

    stopWatch.stop();
  }
}

class Progresso{
  final int tarefaId;
  final int percentual;
  final Duration tempodecorrido;

  Progresso(this.tarefaId,this.percentual,this.tempodecorrido);

  @override
  String toString(){
    return 'Tarefa $tarefaId: $percentual% concluida (${tempodecorrido.inMilliseconds/1000}s)';
  }
}

Future<Duration> executarTarefas(List<Tarefa> tarefas) async{
  final stopwatch = Stopwatch()..start();
  final completer = Completer<Duration>();

  int tarefasReastantes = tarefas.length;

  for(final tarefa in tarefas){
    tarefa.executar().listen(
      (progresso){
        if (progresso.percentual % 20 == 0 || progresso.percentual == 100){
            print(progresso);
        }
      }, onDone: (){
        print('Tarefa ${tarefa.id} concluida em ${tarefa.duracaototal}');
        tarefasReastantes--;
        if(tarefasReastantes ==0){
          stopwatch.stop();
          completer.complete(stopwatch.elapsed);
        }
      }, onError: (e){
        print('erro na tarefa ${tarefa.id}: $e');
        tarefasReastantes --;
        if(tarefasReastantes == 0){
          stopwatch.stop();
          completer.complete(stopwatch.elapsed);
        }
      }
    );
  }

  return completer.future;
}
