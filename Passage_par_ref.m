classdef  Passage_par_ref < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
    end
    
    methods
        function h = Passage_par_ref(data)
		  h.data = data;
		end
    end
    
end



% 
% classdef myClass < handle
% 	properties
% 		data
% 	end
% 	methods
% 		function h = myClass(data)
% 		  h.data = data	;
% 		end
% 	end
% end
% 
% Then defining a function (which could be a method) like
% 
% function myFunction(h)
% 	h.data = h.data+2;
% end
% 



