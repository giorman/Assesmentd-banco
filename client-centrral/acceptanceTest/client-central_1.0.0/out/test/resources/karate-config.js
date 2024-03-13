function fn() {
  const uuid = java.util.UUID.randomUUID();
  const config = {
    headers: {
      'Client-Id': '#{clientId}#',
      'client-secret': '#{clientSecret}#',
      'accept': 'application/vnd.bancolombia.v4+json',
      'channel' : '',
      'message-id': uuid,
      'aid-creator': '',
      'Content-Type': 'application/vnd.bancolombia.v4+json'
    },
    oasUrl: 'co/com/bancolombia/security-access-entitlement-relations-information_3.1.0.yaml',
    urlBase: '#{host}#'+'v3/sales-service/customer-management/security-access-entitlement'
  };

  karate.configure('connectTimeout', 7000);
  karate.configure('readTimeout', 7000);
  karate.configure('ssl', true);
  return config;
}