enum ConnectionStatus {
  welcome, // nouveau
  first, //a fini la page language
  connected, // c'est connecter soit par inscription par login ou par forget password
  disconnected, // logout
  incompleted, // ne s'est pas inscrit
  unknown, //nouveau
}
