**[WARNING, THIS PROJECT IS EXPERIMENTAL AND UNDER ACTIVE DEVELOPMENT]**

# opentelemetry-exporters-datadog

The `opentelemetry-exporters-datadog` gem provides a Datadog exporter for OpenTelemetry for Ruby. Using `opentelemetry-exporters-datadog`, an application can configure OpenTelemetry to export collected tracing data to [Datadog][datadog-home].

## What is OpenTelemetry?

[OpenTelemetry][opentelemetry-home] is an open source observability framework, providing a general-purpose API, SDK, and related tools required for the instrumentation of cloud-native software, frameworks, and libraries.

OpenTelemetry provides a single set of APIs, libraries, agents, and collector services to capture distributed traces and metrics from your application.

## How does this gem fit in?

The `opentelemetry-exporters-datadog` gem is a plugin that provides Datadog Tracing export. To export to Datadog, an application can include this gem along with `opentelemetry-sdk`, and configure the `SDK` to use the provided Datadog exporter as a span processor.

Generally, *libraries* that produce telemetry data should avoid depending directly on specific exporters, deferring that choice to the application developer.

## Setup

- If you use [bundler][bundler-home], include the following in your `Gemfile`:

```
gem 'opentelemetry-exporters-datadog', git: 'https://github.com/Datadog/dd-opentelemetry-exporter-ruby'
gem 'opentelemetry-api', git: 'https://github.com/open-telemetry/opentelemetry-ruby', ref: '0099668e9ad7eedf32bb496e135e8220f1e49c61'
gem 'opentelemetry-sdk', git: 'https://github.com/open-telemetry/opentelemetry-ruby', ref: '0099668e9ad7eedf32bb496e135e8220f1e49c61'
```

- Then, configure the SDK to use the Datadog exporter as a span processor, and use the OpenTelemetry interfaces to produces traces and other information. Following is a basic example.

```ruby
require 'opentelemetry/sdk'
require 'opentelemetry-exporters-datadog'

# Configure the sdk with custom export
OpenTelemetry::SDK.configure do |c|
  c.add_span_processor(
    OpenTelemetry::Exporters::Datadog::DatadogSpanProcessor.new(
      OpenTelemetry::Exporters::Datadog::Exporter.new(
        service_name: 'my_service', agent_url: 'http://localhost:8126'
      )
    )
  )
end

# For propagation of datadog specific distibuted tracing headers,
# set http propagation to the Composite Propagator

OpenTelemetry::Exporters::Datadog::Propagator.auto_configure

# For manual configuration of propagation of datadog specific distibuted tracing headers,
# add the Datadog Propagator to the list of extractors and injectors, like below

# extractors = [
#   OpenTelemetry::Trace::Propagation::TraceContext.rack_extractor,
#   OpenTelemetry::CorrelationContext::Propagation.rack_extractor,
#   OpenTelemetry::Exporters::Datadog::Propagator.new
# ]
# injectors = [
#   OpenTelemetry::Trace::Propagation::TraceContext.text_injector,
#   OpenTelemetry::CorrelationContext::Propagation.text_injector,
#   OpenTelemetry::Exporters::Datadog::Propagator.new
# ]
# OpenTelemetry.propagation.http = OpenTelemetry::Context::Propagation::CompositePropagator.new(injectors, extractors)

# To start a trace you need to get a Tracer from the TracerProvider
tracer = OpenTelemetry.tracer_provider.tracer('my_app_or_gem', '0.1.0')

# create a span
tracer.in_span('foo') do |span|
  # set an attribute
  span.set_attribute('platform', 'osx')
  # add an event
  span.add_event(name: 'event in bar')
  # create bar as child of foo
  tracer.in_span('bar') do |child_span|
    # inspect the span
    pp child_span
  end
end
```

For additional examples, see the [examples on github][examples-github].

## Probability Based Sampling Setup

- By default, the OpenTelemetry tracer will sample and record all spans. This default is the suggest sampling approach to take when exporting to Datadog. However, if you wish to use Probability Based sampling, we recommend that, in order for the Datadog trace-agent to collect trace related metrics effectively, to use the `DatadogProbabilitySampler`. You can enabled Datadog Probability based sampling with the  code snippet below.

```ruby
#sampling rate must be a value between 0.0 and 1.0
sampling_rate = 0.75 
OpenTelemetry.tracer_provider.active_trace_config  = OpenTelemetry::SDK::Tracer::Config::Tracer::TraceConfig.new(
  sampler: OpenTelemetry::SDK::Trace::Export::DatadogProbabilitySampler.default_with_probability(sampling_rate)
)
```

## Configuration Options

#### Configuration Options - Datadog Agent URL

By default the OpenTelemetry Datadog Exporter transmits traces to localhost:8126. You can configure the application to send traces to a diffent URL using the following environmennt variables:

 - `DD_TRACE_AGENT_URL`: The `<host>:<port:` where you Datadog Agent is listening for traces. (e.g. `agent-host:8126`)

These values can also be overridden at the trace exporter level:

```ruby
# Configure the sdk with custom export
OpenTelemetry::SDK.configure do |c|
  c.add_span_processor(
    OpenTelemetry::Exporters::Datadog::DatadogSpanProcessor.new(
      OpenTelemetry::Exporters::Datadog::Exporter.new(
        service_name: 'my_service',
        agent_url: 'http://dd-agent:8126',
      )
    )
  )
end
```

#### Configuration Options - Tagging

You can configure the application to automatically tag your Datadog exported traces, using the following environment variables:

 - `DD_ENV`: Your application environment (e.g. `production`, `staging`, etc.)
 - `DD_SERVICE`: Your application's default service name (e.g. `billing-api`)
 - `DD_VERSION`: Your application version (e.g. `2.5`, `202003181415`, `1.3-alpha`, etc.)
 - `DD_TAGS`: Custom tags in value pairs separated by `,` (e.g. `layer:api,team:intake`)
    - If `DD_ENV`, `DD_SERVICE` or `DD_VERSION` are set, it will override any respective `env`/`service`/`version` tag defined in `DD_TAGS`.
    - If `DD_ENV`, `DD_SERVICE` or `DD_VERSION` are NOT set, tags defined in `DD_TAGS` will be used to populate `env`/`service`/`version` respectively.

These values can also be overridden at the trace exporter level:

```ruby
# Configure the sdk with custom export
OpenTelemetry::SDK.configure do |c|
  c.add_span_processor(
    OpenTelemetry::Exporters::Datadog::DatadogSpanProcessor.new(
      OpenTelemetry::Exporters::Datadog::Exporter.new(
        service_name: 'my_service',
        agent_url: 'http://localhost:8126',
        env: 'prod',
        version: '1.5-alpha',
        tags: 'team:ops,region:west'
      )
    )
  )
end
```

This enables you to set this value on a per application basis, so you can have for example several applications reporting for different environments on the same host.

Tags can also be set directly on individual spans, which will supersede any conflicting tags defined at the application level.

## How can I get involved?

The `opentelemetry-exporters-datadog` gem source is [on github][repo-github], along with related gems including `opentelemetry-sdk`.

The OpenTelemetry Ruby gems are maintained by the OpenTelemetry-Ruby special interest group (SIG). You can get involved by joining us on our [gitter channel][ruby-gitter] or attending our weekly meeting. See the [meeting calendar][community-meetings] for dates and times. For more information on this and other language SIGs, see the OpenTelemetry [community page][ruby-sig].

## License

The `opentelemetry-exporter-datadog` gem is distributed under the Apache 2.0 license. See [LICENSE][license-github] for more information.


[datadog-home]: https://www.datadoghq.com
[opentelemetry-home]: https://opentelemetry.io
[bundler-home]: https://bundler.io
[repo-github]: https://github.com/open-telemetry/opentelemetry-ruby
[license-github]: https://github.com/open-telemetry/opentelemetry-ruby/blob/master/LICENSE
[examples-github]: https://github.com/open-telemetry/opentelemetry-ruby/tree/master/examples
[ruby-sig]: https://github.com/open-telemetry/community#ruby-sig
[community-meetings]: https://github.com/open-telemetry/community#community-meetings
[ruby-gitter]: https://gitter.im/open-telemetry/opentelemetry-ruby
