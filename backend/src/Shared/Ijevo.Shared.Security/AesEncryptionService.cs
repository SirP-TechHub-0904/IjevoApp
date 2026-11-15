using System.Security.Cryptography;
using System.Text;

namespace Ijevo.Shared.Security;

public interface IAesEncryptionService
{
    string Encrypt(string plainText);
    string Decrypt(string cipherText);
}

public class AesEncryptionService : IAesEncryptionService
{
    private readonly byte[] _key;

    public AesEncryptionService(string secretKey)
    {
        if (string.IsNullOrWhiteSpace(secretKey))
        {
            throw new InvalidOperationException(
                "CRITICAL SECURITY CONFIGURATION ERROR: 'Security:AesKey' is missing. " +
                "Please configure an encryption key in appsettings.json or your secret vault.");
        }

        // Support both:
        // 1. Direct 32-byte Base64 strings (44 characters)
        // 2. Long enterprise passphrases/tokens (64 to 256+ characters), securely derived to 256-bit via SHA-256
        if (TryGet32ByteBase64Key(secretKey, out var directKey))
        {
            _key = directKey;
        }
        else
        {
            // Derive a 256-bit (32-byte) key using SHA-256
            _key = SHA256.HashData(Encoding.UTF8.GetBytes(secretKey));
        }
    }

    private static bool TryGet32ByteBase64Key(string candidate, out byte[] key)
    {
        key = [];
        try
        {
            var bytes = Convert.FromBase64String(candidate);
            if (bytes.Length == 32)
            {
                key = bytes;
                return true;
            }
        }
        catch
        {
            // Not base64, fall through to key derivation
        }
        return false;
    }

    public string Encrypt(string plainText)
    {
        if (string.IsNullOrEmpty(plainText)) return plainText;

        using var aes = Aes.Create();
        aes.Key = _key;
        aes.GenerateIV();

        using var encryptor = aes.CreateEncryptor(aes.Key, aes.IV);
        var plainBytes = Encoding.UTF8.GetBytes(plainText);
        var encryptedBytes = encryptor.TransformFinalBlock(plainBytes, 0, plainBytes.Length);

        // Prepend IV to cipher payload
        var result = new byte[aes.IV.Length + encryptedBytes.Length];
        Buffer.BlockCopy(aes.IV, 0, result, 0, aes.IV.Length);
        Buffer.BlockCopy(encryptedBytes, 0, result, aes.IV.Length, encryptedBytes.Length);

        return Convert.ToBase64String(result);
    }

    public string Decrypt(string cipherText)
    {
        if (string.IsNullOrEmpty(cipherText)) return cipherText;

        try
        {
            var fullCipher = Convert.FromBase64String(cipherText);
            using var aes = Aes.Create();
            aes.Key = _key;

            var iv = new byte[aes.BlockSize / 8];
            var cipher = new byte[fullCipher.Length - iv.Length];

            Buffer.BlockCopy(fullCipher, 0, iv, 0, iv.Length);
            Buffer.BlockCopy(fullCipher, iv.Length, cipher, 0, cipher.Length);

            using var decryptor = aes.CreateDecryptor(aes.Key, iv);
            var decryptedBytes = decryptor.TransformFinalBlock(cipher, 0, cipher.Length);
            return Encoding.UTF8.GetString(decryptedBytes);
        }
        catch
        {
            // Fallback if data was already in plain text prior to encryption
            return cipherText;
        }
    }
}
