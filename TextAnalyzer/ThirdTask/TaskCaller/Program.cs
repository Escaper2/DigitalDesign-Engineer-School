using System.Net.Http.Json;
using System.Text;
using WebApi.Models;

namespace ThirdTaskCaller
{
    internal class Program
    {
        private const string FolderPath = "..\\..\\..\\..\\..\\Resources\\";


        static async Task Main()
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);

            var path = Path.Combine(FolderPath, "voyna-i-mir-tom-1" + ".txt");

            var resultFile = Path.Combine(FolderPath, "Result.txt");

            var allText = File.ReadAllText(path, Encoding.GetEncoding(1251));

            HttpClient client = new HttpClient();

            TextModel model = new TextModel() { Text = allText };

            JsonContent body = JsonContent.Create(model);

            using var response = await client.PostAsync("https://localhost:7032/api/Text", body);

            response.EnsureSuccessStatusCode();

            var contents = await response.Content.ReadFromJsonAsync<IEnumerable<string>>();

            await File.WriteAllLinesAsync(resultFile, contents!);
        }
    }
}