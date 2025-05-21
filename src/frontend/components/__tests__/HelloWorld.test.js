import { mount } from '@vue/test-utils'
import HelloWorld from '../HelloWorld.vue'

describe('HelloWorld.vue', () => {
  it('renders props.msg', () => {
    const wrapper = mount(HelloWorld, {
      propsData: { msg: 'Hello Jest' }
    })
    expect(wrapper.text()).toMatch('Hello Jest')
  })
})
