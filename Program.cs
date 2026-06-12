var builder = WebApplication.CreateBuilder(args);

// Bind from app config (defaults to all interfaces on 5000). Setting this in code
// makes it win over the base image's ASPNETCORE_HTTP_PORTS default, so the listen
// port travels with the app instead of depending on the environment.
builder.WebHost.UseUrls(builder.Configuration["ApiHost:Uri"] ?? "http://0.0.0.0:5000");

var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.MapGet("/health", () => new { status = "Healthy" });

app.Run();
