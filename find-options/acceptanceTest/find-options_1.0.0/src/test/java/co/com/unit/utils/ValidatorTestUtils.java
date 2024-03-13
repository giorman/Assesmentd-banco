package co.com.unit.utils;

import com.atlassian.oai.validator.OpenApiInteractionValidator;
import com.atlassian.oai.validator.model.Request;
import com.atlassian.oai.validator.model.Response;
import com.atlassian.oai.validator.model.SimpleRequest;
import com.atlassian.oai.validator.model.SimpleResponse;

import com.atlassian.oai.validator.report.ValidationReport;

public class ValidatorTestUtils {
  public static String contentType = "application/json";
  public static final String POST = "POST";
  public static final String GET = "GET";
  public static final String PUT = "PUT";
  public static final String DELETE = "DELETE";
  public static final String OPTIONS = "OPTIONS";
  public static final String HEAD = "HEAD";

  public static void setContentType(String _contentType) {
    contentType = _contentType;
  }

  public static ValidationReport validateSchema(String oasUrl, String requestJson, String responseJson,
      String path, String method, int status) {

    OpenApiInteractionValidator validator = OpenApiInteractionValidator
        .createForSpecificationUrl(oasUrl).build();

    Request request = SimpleRequest.Builder
            .post(path)
            .withContentType(contentType)
            .withBody(requestJson)
            .build();
    Response response = SimpleResponse.Builder
        .status(status)
        .withContentType(contentType)
        .withBody(responseJson)
        .build();

    ValidationReport requestReport = validator.validateRequest(request);
    System.out.println("Request Valido= "+!requestReport.hasErrors());
    ValidationReport responseReport = validator.validateResponse(path, Request.Method.valueOf(method), response);
    System.out.println("Response Valido= "+!responseReport.hasErrors());

    ValidationReport report = requestReport.merge(responseReport);

    return report;
  }

}