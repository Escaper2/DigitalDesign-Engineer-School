using Microsoft.AspNetCore.Mvc;
using WebApi.Models;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TextController : ControllerBase
    {

        private readonly ILogger<TextController> _logger;

        public TextController(ILogger<TextController> logger)
        {
            _logger = logger;
        }

        [HttpPost]
        public IEnumerable<string> AnalyzeText(TextModel model)
        {
            var textProcessor = new Dll.TextProcessor();

            return textProcessor.RunParallel(model.Text);

        }
    }
}