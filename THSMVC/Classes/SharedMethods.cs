using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Configuration;
using System.Security.Cryptography;

namespace THSMVC.App_Code
{
    public class SharedMethods : IDisposable
    {
        // Track whether Dispose has been called.
        private bool disposed = false;
        // Implement IDisposable.
        // Do not make this method virtual.
        // A derived class should not be able to override this method.
        public void Dispose()
        {
            Dispose(true);
            // This object will be cleaned up by the Dispose method.
            // Therefore, you should call GC.SupressFinalize to
            // take this object off the finalization queue
            // and prevent finalization code for this object
            // from executing a second time.
            GC.SuppressFinalize(this);
        }

        // Dispose(bool disposing) executes in two distinct scenarios.
        // If disposing equals true, the method has been called directly
        // or indirectly by a user's code. Managed and unmanaged resources
        // can be disposed.
        // If disposing equals false, the method has been called by the
        // runtime from inside the finalizer and you should not reference
        // other objects. Only unmanaged resources can be disposed.
        protected virtual void Dispose(bool disposing)
        {
            // Check to see if Dispose has already been called.
            if (!this.disposed)
            {
                // If disposing equals true, dispose all managed
                // and unmanaged resources.
                if (disposing)
                {
                    // Dispose managed resources.
                    //logiclayer.Dispose();
                }

                // Note disposing has been done.
                disposed = true;

            }
        }

        // Use C# destructor syntax for finalization code.
        // This destructor will run only if the Dispose method
        // does not get called.
        // It gives your base class the opportunity to finalize.
        // Do not provide destructors in types derived from this class.
        ~SharedMethods()
        {
            // Do not re-create Dispose clean-up code here.
            // Calling Dispose(false) is optimal in terms of
            // readability and maintainability.
            Dispose(false);
        }
    }

    public interface IEncryptString
    {
        string Encrypt(string value);
        string Decrypt(string value);
        string Prefix { get; }
    }
    public class ConfigurationBasedStringEncrypter : IEncryptString
    {
        private static readonly ICryptoTransform _encrypter;
        private static readonly ICryptoTransform _decrypter;
        private static string _prefix;
        static ConfigurationBasedStringEncrypter()
        {
            //read settings from configuration 
            var key = ConfigurationManager.AppSettings["EncryptionKey"];
            var useHashingString = "true";
            bool useHashing = true;
            if (string.Compare(useHashingString, "false", true) == 0)
            {
                useHashing = false;
            }

            var prefix = ConfigurationManager.AppSettings["EncryptionPrefix"];
            if (string.IsNullOrWhiteSpace(prefix))
            {
                _prefix = "encryptedHidden_";
            }
            byte[] keyArray = null;

            if (useHashing)
            {
                using (var hashmd5 = new MD5CryptoServiceProvider())
                {
                    keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key));
                    hashmd5.Clear();
                }
            }
            else
            {
                keyArray = UTF8Encoding.UTF8.GetBytes(key);
            }

            using (TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider())
            {
                tdes.Key = keyArray;
                tdes.Mode = CipherMode.ECB;
                tdes.Padding = PaddingMode.PKCS7;

                _encrypter = tdes.CreateEncryptor();
                _decrypter = tdes.CreateDecryptor();

                tdes.Clear();
            }
        }

        #region IEncryptionSettingsProvider Members

        public string Encrypt(string value)
        {
            var bytes = UTF8Encoding.UTF8.GetBytes(value);
            var encryptedBytes = _encrypter.TransformFinalBlock(bytes, 0, bytes.Length);
            var encrypted = Convert.ToBase64String(encryptedBytes);
            return encrypted;
        }

        public string Decrypt(string value)
        {
            var bytes = Convert.FromBase64String(value);
            var decryptedBytes = _decrypter.TransformFinalBlock(bytes, 0, bytes.Length);
            var decrypted = UTF8Encoding.UTF8.GetString(decryptedBytes);
            return decrypted;
        }

        public string Prefix
        {
            get { return _prefix; }
        }

        #endregion

    }
}