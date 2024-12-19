exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const uri = request.uri;

  if (!uri.includes('.') && !uri.endsWith('/')) {
    request.uri += '/';
  }

  callback(null, request);
}
