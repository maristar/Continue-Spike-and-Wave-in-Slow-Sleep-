function exportHTML(filename, A)
% Usage: exportHTML('test.html',A)
title = 'html title';
heading = 'name of the table';

[m,n]=size(A);

f = fopen(filename,'w');
fprintf(f,'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">\n');
fprintf(f,'<HTML>\n');
fprintf(f,'<HEAD>\n');
fprintf(f,'<TITLE>%s</TITLE>\n',title);
fprintf(f,'</HEAD>\n');
fprintf(f,'<BODY>\n');
fprintf(f,'<P>%s\n',heading);

fprintf(f,'<TABLE>\n');
for it1=1:m,
    fprintf(f,'<TR><TH>');
    for it2=1:n,
        fprintf(f,'<TD>%f',A(m,n));
    end
    fprintf(f,'</TR>\n');
end
fprintf(f,'</TABLE>\n');

fprintf(f,'</BODY>\n');
fprintf(f,'</HTML>\n');

fclose(f);