/*La funzione checkLevel verifica in che livello si trova l'utente in basa alla distanza percorsa e ai posti visitati*/
int checkLevel(double distance, int n_visited_places){
  if(distance <= 10.0 || n_visited_places <= 3){
    return 1;
  }
  
  if((distance > 10.0 && distance <= 100.0) || (n_visited_places > 3 && n_visited_places <= 7)){
      return 2;
  }

  if (distance > 100.0 && n_visited_places > 7){
      return 3;
  }

  return 1;
}