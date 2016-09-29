## Using data attributes

HTML5는 특정 엘리먼트와 associated되야하는 data에 대한 확장성으로 고안되었다.
data-* attributes로 extra 정보를 표준으로 저장할 수 있다.
비표준과 같은 attribute, extra properties on DOM or setUserData 그런 거 없이 semantic HTML element로 저장 가능


### HTML syntax
- data-로 시작

### CSS Access
data attribute는 plain HTML attribute기 때문에, CSS로 접근할 수 있다.
예를 들어 article의 parent data를 보여주기 위해, attr() function CSS로 생성된 컨텐츠를 사용할 수 있다.

  article::before {
    content: attr(data-parent);
  }

data에 따라 style을 변경하기 위해 attribute selector도 사용할 수 있다.

  article[data-columns='3'] {
    width : 400px;
  }

  article[data-columns='4'] {
    width : 600px;
  }

Data attribute는 순간 변하는 정보를 포함하기 위해 저장된다. (like scores in a game) CSS and Javascript selector를 이용하는 것은 own display routine 작성하는 것 없이 재빠른 효과를 빌드하도록 허용한다


### Issue
visible and accessible 해야하는 content는 data attribute에 저장하지 말자. 왜냐하면 assistive technology는 그것들을 접근하지 못한다.
