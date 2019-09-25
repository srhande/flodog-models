% prepare the params.norm struct
%
% Paul Hammon
% 7/12/05
%
% Revision History:
% 5/19/14 -- (EM) removed add_const from parameter list - it is now found
%            in params
%
% type -- normalization type can be one of:
%         'odog': global normalization
%         'lodog': localized oriented normalization
%         'flodog': frequency-dependent localized oriented normalization
%         'unodog': unnormalized
%         'divsome': 
%         'divmix':
%         'divmixinv': 
%         'divall':
%         'divallbm': 
%         'divsome128': 
%         'desa': 
% sig1fun -- create an inline function for setting the extent 
%            of the normaliztion in the direction of the filter
%            can take frequency information (f) or
%            orientation (o)
% sr -- extent perpendicular to filter (as a multiple of sig1fun)
% (optional) x -- extent of normalization mask in x
% (optional) y -- extent of normalization mask in y
% (optional) fft_adjust -- fix for FFT inaccuracies (to prevent divide by
%                          zero)
%
% params = prep_norm(params, type, sig1fun, sr, x, y, fft_adjust)
function params = prep_norm(params, type, sig1fun, sr, add_const, x, y, fft_adjust)

% if x, y, fft_adjust not passed, set to default
if(nargin == 5)
    % assign the passed values
    params.norm.type = type;                % type of normalization
    params.norm.sig1fun = inline(sig1fun);  % extent n times filter size
    params.norm.sr = sr;                    % extent perpendicular to filter
    params.const.ADD_CONST = add_const;      % additive constant for normalization
elseif nargin == 8
    params.norm.type = type;                % type of normalization
    params.norm.sig1fun = inline(sig1fun);  % extent n times filter size
    params.norm.sr = sr;                    % extent perpendicular to filter
    params.const.ADD_CONST = add_const;      % additive constant for normalization
    params.norm.x = x;                      % extent of normalization mask in x
    params.norm.y = y;                      % extent of normalization mask in y
    params.norm.fft_adjust = fft_adjust;    % fix for FFT inaccuracies
end

% update history
params.history{length(params.history) + 1} = 'prep_norm';

% setup the settings, which can be used for plot titles and save files
if(isempty(params.norm.sr))
    params.norm.settings = type;
elseif strcmp(type, 'lapdog')
    params.norm.settings = [type '_corr_exp_' num2str(sr) '_add' num2str(add_const)];
else
    params.norm.settings = [type '_sig' strrep(sig1fun, '*', '') '_sr' num2str(sr) '_add' num2str(add_const)]; 
end
