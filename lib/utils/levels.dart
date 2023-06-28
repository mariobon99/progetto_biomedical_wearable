class Levels {
  static const String title1 = 'Livello Bradipo!';
  static const String imagePath1 = 'assets/images/Bradipo.jpeg';
  static const String description1 =
      'Sei un vero e proprio bradipo! Sei così rilassato e tranquillo che sembra che tu stia meditando mentre cammini! Le tue mosse sono così lente che le formiche ti superano facilmente. Ma non preoccuparti, abbiamo dei luoghi per te dove potrai goderti il tuo ritmo lento e rilassato. Non hai bisogno di fretta quando si tratta di divertirti.';

  static const String title2 = 'Livello Gazzella!';
  static const String imagePath2 = 'assets/images/Gazzella.jpeg';
  static const String description2 =
      'Sei una gazzella inarrestabile! \nSalti, corri e balli ovunque tu vada. Sei un vero e proprio spettacolo da vedere e la tua energia contagiosa ispira tutti quelli intorno a te. Hai un\'attenzione incredibile per i dettagli, proprio come la gazzella che sfrutta ogni opportunità.\nTi mostreremo i luoghi più vivaci di Padova, dove potrai saltellare felice come una gazzella.';
  
  static const String title3 = 'Livello Ghepardo!';
  static const String imagePath3 = 'assets/images/Ghepardo.jpeg';
  static const String description3 =
    'Sei un ghepardo supersprint! \nLa tua velocità è leggendaria e nessuno riesce a tenerti il passo. Vedi un obiettivo e lo raggiungi in un batter d\' occhio. Sei unvero eserto nel trascinare gli amici pigri a fare attività fisica.\nAbbiamo selezionato dei luoghi perfetti per te, dove potrai mettere all aprova la tua velocità e goderti l\'adrenalina della corsa come un vero ghepardo';
}

/*La funzione prende in input livello, distanza e posti visitati dal database.
  A questo punto verifica se è stato sbloccato un nuovo livello e ritorna il livello sbloccato, altrimenti ritorna 0:
    - se il livello è 1 non è necessario aggiornare il db in quanto è il livello base (return 0)
    - se ho sblocato il livello 2 è necessario aggiornare il livello passando a 2 (return 2)
    - se ho sblocato il livello 3 è necessario aggiornare il livello passando a 3 (return 3)
 */
int levelOvertake(int level, double distance, int n_visited_places){
  if(distance <= 10.0 || n_visited_places <= 3){
    //nessun aggiornamento a database e quindi ritorno 1
    return 0;
  }

  if((distance > 10.0 && distance <= 100.0) || (n_visited_places > 3 && n_visited_places <= 7)){
    if(level != 2){
      //update del livello nel database a 2
      return 2;
    }
    return 0;
  }

  if(distance > 100.0 && n_visited_places > 7){
    if(level != 3){
      //update del livello nel database a 3
      return 3;
    }
    return 0;
  }
  
  return 0;
}