function res = hash(str)
% Return the MD5 hash (modified) of given string
% 
% PARAMETERS:
% -----------
% str (string/char): string whose hash is to be computed.

    import java.security.*;
    import java.math.*;
    md = MessageDigest.getInstance('MD5');
    hash = md.digest(double(str));
    bi = BigInteger(1, hash);
    res = char(bi.toString(16)); 
    res = string(res); 
    % the name of a field in a struct must not begin with a number 
    % to make sure this hash value is ALWAYS good to be used as a field 
    % name in a struct (its intended use in FreqModel), we add a prefix "f_"
    res = "f_" + res; 
end 