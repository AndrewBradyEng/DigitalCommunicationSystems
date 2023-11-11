%% Shannon-Fano Algorithm
% Algorithm for entropy encoding
% Andrew Brady
% C20769822
% TU821/4
%% Function
function shannonFano()
%% Initialisation and Helper Function

    % Declare structure node
    function nd = createNode() %Helper function to create a node with default values
        nd.sym = '';
        nd.pro = 0.0;
        nd.arr = zeros(1, 20);
        nd.top = 0;
    end

    p = arrayfun(@(~) createNode(), 1:20); %Initialise array of nodes

%% Shannon-Fano Algorithm Functions 

    % Function to find shannon code
    function shannon(l, h)
        pack1 = 0; pack2 = 0; diff1 = 0; diff2 = 0;
        if ((l + 1) == h || l == h || l > h)
            if (l == h || l > h)
                return;
            end
            %Assign codes for symbols 1 and h
            p(h).top = p(h).top + 1;
            p(h).arr(p(h).top + 1) = 0;
            p(l).top = p(l).top + 1;
            p(l).arr(p(l).top + 1) = 1;
            return;
        else
            %Calculate probabilities and find split inde
            for i = l:h-1
                pack1 = pack1 + p(i).pro;
            end
            pack2 = pack2 + p(h).pro;
            diff1 = pack1 - pack2;
            if (diff1 < 0)
                diff1 = diff1 * -1;
            end
            j = 2;
            while (j ~= h - l + 2)
                k = h - j;
                pack1 = 0; pack2 = 0;
                for i = l:k
                    pack1 = pack1 + p(i).pro;
                end
                for i = h:-1:k+1
                    pack2 = pack2 + p(i).pro;
                end
                diff2 = pack1 - pack2;
                if (diff2 < 0)
                    diff2 = diff2 * -1;
                end
                if (diff2 >= diff1)
                    break;
                end
                diff1 = diff2;
                j = j + 1;
            end
            k = k + 1;
            %Assign codes for symbols in the range [l, k]
            for i = l:k
                p(i).top = p(i).top + 1;
                p(i).arr(p(i).top + 1) = 1;
            end
            %Assign codes for symbols in the range [k, h]
            for i = k + 1:h
                p(i).top = p(i).top + 1;
                p(i).arr(p(i).top + 1) = 0;
            end

            % Recursively invoke shannon function for both halves
            shannon(l, k);
            shannon(k + 1, h);
        end
    end

    % Function to sort the symbols based on their probability
    function sortByProbability(n)
    [~, index] = sort([p(1:n).pro]);
    p(1:n) = p(index);
    end

%% Display & Driver code

    % Function to display shannon codes
    function display(n)
    fprintf('\n\n\n\tSymbol\tProbability\tCode');
        for i = n:-1:1
            fprintf('\n\t%s\t\t%.2f\t%s', p(i).sym, p(i).pro, num2str(p(i).arr(1:p(i).top + 1), '%d'));
        end
    end

    total = 0;

    % Input number of symbols
    n = 8;

    % Input symbols
    for i = 1:n
        ch = char(65 + i - 1);
        p(i).sym = ch;
    end

    % Input probability of symbols
    x = [0.25, 0.15, 0.12, 0.1, 0.1, 0.08, 0.07, 0.13];
    for i = 1:n
        p(i).pro = x(i);
        total = total + p(i).pro;

        %Check for invalid input
        if (total > 1)
            fprintf('Invalid. Enter new values\n');
            total = total - p(i).pro;
            i = i - 1;
        end
    end
    i = i + 1;
    p(i).pro = 1 - total;

    %Sort the symbols based on their probability
    sortByProbability(n);

    for i = 1:n
        p(i).top = -1;
    end

    % Find the shannon code
    shannon(1, n);

    % Display the codes
    display(n);

end
