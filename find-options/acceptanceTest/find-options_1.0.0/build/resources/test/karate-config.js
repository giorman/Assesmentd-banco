function fn() {
  const uuid = java.util.UUID.randomUUID();
  const config = {
    headers: {
      'client-id': '81b0af8081335b326a4040abcfe16e86',
      'client-secret': 'c4c99959ccfd61e30e11f15ac75e4aff',
      'accept': 'application/json',
      'message-id': '728a0e12-1aea-4887-84bb-fc19fd05cf74',
      'Content-Type': 'application/json'
    },
    oasUrl: 'co/com/unit/find-options-information_1.0.0.yaml',
    urlBase: 'https://api.us-east-a.apiconnect.ibmappdomain.cloud/apiconect/sandbox/v1/service/find-options-information'
  };

  karate.configure('connectTimeout', 7000);
  karate.configure('readTimeout', 7000);
  karate.configure('ssl', true);
  return config;
}