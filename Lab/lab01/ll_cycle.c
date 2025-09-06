#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    if(!head || !(head->next)) return 0;
    node *slow = head;
    node *fast = head->next;
    while(fast && fast->next)
    {
        if(slow == fast)
            return 1;
        slow = slow->next;
        fast = fast->next->next;
    }
    return 0;
}