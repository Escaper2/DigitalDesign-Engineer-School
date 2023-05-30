using System.Text.RegularExpressions;

namespace Dll
{
    public class TextProcessor
    {
        private const string FolderPath = "..\\..\\..\\..\\Resources\\";

        public IEnumerable<string> RunParallel(string allText)
        {

            var resultFile = Path.Combine(FolderPath, "Result.txt");

            string[] splitWords = new Regex("[^a-zA-Zа-яА-Я]|\\b[a-zA-Zа-яА-Яё]{1,3}\\b").Replace(allText, " ").ToLower().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            var uniqueWords = splitWords.AsParallel()
                .GroupBy(x => x).OrderByDescending(x => x.Count());

            return uniqueWords.Select(gr => $"{gr.Key} {gr.Count()}");

        }

        private IEnumerable<string> Run(string allText)
        {

            var resultFile = Path.Combine(FolderPath, "Result.txt");

            string[] splitWords = new Regex("[^a-zA-Zа-яА-Я]|\\b[a-zA-Zа-яА-Яё]{1,3}\\b").Replace(allText, " ").ToLower().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            var uniqueWords = splitWords.GroupBy(x => x).OrderByDescending(x => x.Count());

            return uniqueWords.Select(gr => $"{gr.Key} {gr.Count()}");

        }

    }
}