using System.Text.RegularExpressions;

namespace FirstTask
{
    public class TextProcessorDLL
    {
        private const string FolderPath = "..\\..\\..\\Resources\\";

        private IEnumerable<string> Run(string allText)
        {

            var resultFile = Path.Combine(FolderPath, "Result.txt");

            string[] splitWords = new Regex("[^a-zA-Zа-яА-Я]|\\b[a-zA-Zа-яА-Яё]{1,3}\\b").Replace(allText, " ").ToLower().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            var uniqueWords = splitWords.GroupBy(x => x).OrderByDescending(x => x.Count());

            return uniqueWords.Select(gr => $"{gr.Key} {gr.Count()}");

        }

    }
}