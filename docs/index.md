# Welcome to our documentation


Brief overview.

```` mermaid
%%{init: {'theme':'base'}}%%
graph TD;

Client1[External client];
R2 -- Read state --> Client1;
Client1 -- Send transactions --> F2;


subgraph PBC[PBC network]
    subgraph Node 2
        L2[Ledger];
        L2 --- R2[REST server];
        L2 --- F2[Flooding network];
    end

    subgraph Node 1
        L1[Ledger] --- C1[Consensus node];
        L1 --- R1[REST server];
        L1 --- F1[Flooding network];
    end

    F2 --> F1
    F1 --> F2
end


classDef className fill:#FFFFFF,stroke:#333,stroke-width:1px;
class PBC className;
````
